#include "plmprojecthub.h"
#include <QDateTime>
#include <QDebug>
#include <QDir>
#include <QFileInfo>
#include <QRegularExpression>
#include <QUrl>
#include <QVariant>
#include "tasks/plmprojectmanager.h"
#include "tasks/plmsqlqueries.h"
#include <tasks/sql/plmimporter.h>
#include "plmdata.h"

PLMProjectHub::PLMProjectHub(QObject *parent) : QObject(parent),
    m_tableName("tbl_project"), m_activeProject(-2), m_isProjectToBeClosed(-2)
{
    // connection for 'getxxx' functions to have a way to get errors.
    connect(this,
            &PLMProjectHub::errorSent,
            this,
            &PLMProjectHub::setError,
            Qt::DirectConnection);
}

SKRResult PLMProjectHub::loadProject(const QUrl& urlFilePath, bool hidden)
{
    if (!hidden) {
        emit projectToBeLoaded();
    }

    int projectId    = -1;
    SKRResult result = plmProjectManager->loadProject(urlFilePath, projectId);

    result.addData("projectId", projectId);

    IFOK(result) {
        plmdata->treeHub()->renumberSortOrders(projectId);

        if (!hidden) {
            m_projectsNotModifiedOnceList.append(projectId);
            emit projectLoaded(projectId);
            emit projectCountChanged(this->getProjectCount());
            emit isThereAnyLoadedProjectChanged(true);

            this->setActiveProject(projectId);

            if (urlFilePath.isEmpty()) {
                this->setProjectNotSavedAnymore(projectId);
            }
        }
    }

    IFKO(result) {
        emit errorSent(result);
    }

    return result;
}

SKRResult PLMProjectHub::createNewEmptyProject(const QUrl& path, bool hidden)
{
    int projectId    = -1;
    SKRResult result = plmProjectManager->createNewEmptyDatabase(projectId);

    result.addData("projectId", projectId);

    IFOK(result) {
        plmdata->treeHub()->renumberSortOrders(projectId);

        if (!hidden) {
            m_projectsNotModifiedOnceList.append(projectId);
            emit projectLoaded(projectId);
            emit projectCountChanged(this->getProjectCount());
            emit isThereAnyLoadedProjectChanged(true);

            this->setActiveProject(projectId);
            this->setProjectNotSavedAnymore(projectId);
        }
    }
    IFOK(result) {
        if (path.isValid()) {
            result = this->saveProjectAs(projectId, this->getProjectType(projectId), path);
        }
    }

    IFKO(result) {
        emit errorSent(result);
    }
    return result;
}

SKRResult PLMProjectHub::createSilentlyNewSpecificEmptyProject(const QUrl& path, const QString& sqlFile)
{
    int projectId    = -1;
    SKRResult result = plmProjectManager->createNewSpecificEmptyDatabase(projectId, sqlFile);

    result.addData("projectId", projectId);

    IFOK(result) {
        plmdata->treeHub()->renumberSortOrders(projectId);
    }
    IFOK(result) {
        if (path.isValid()) {
            result = this->saveProjectAs(projectId, this->getProjectType(projectId), path);
        }
    }

    IFKO(result) {
        emit errorSent(result);
    }
    return result;
}

SKRResult PLMProjectHub::saveProject(int projectId)
{
    SKRResult result(this);

    result = plmProjectManager->saveProject(projectId);
    IFOK(result) {
        m_projectsNotModifiedOnceList.removeAll(projectId);
        m_projectsNotSavedList.removeAll(projectId);
        emit projectSaved(projectId);
    }


    IFKO(result) {
        emit errorSent(result);
    }

    return result;
}

///
/// \brief PLMProjectHub::setProjectNotSavedAnymore
/// \param projectId
/// called every modification
void PLMProjectHub::setProjectNotSavedAnymore(int projectId)
{
    m_projectsNotModifiedOnceList.removeAll(projectId);

    if (!m_projectsNotSavedList.contains(projectId)) {
        m_projectsNotSavedList.append(projectId);
    }
    emit projectNotSavedAnymore(projectId);
}

QList<int>PLMProjectHub::projectsNotModifiedOnce() {
    return m_projectsNotModifiedOnceList;
}

bool PLMProjectHub::isProjectNotModifiedOnce(int projectId)
{
    return m_projectsNotModifiedOnceList.contains(projectId);
}

bool PLMProjectHub::isProjectSaved(int projectId)
{
    return !m_projectsNotSavedList.contains(projectId);
}

QList<int>PLMProjectHub::projectsNotSaved() {
    return m_projectsNotSavedList;
}

SKRResult PLMProjectHub::saveProjectAs(int            projectId,
                                       const QString& type,
                                       const QUrl   & path)
{
    SKRResult result(this);

    // determine if this is a backup project
    bool isThisABackup = isThisProjectABackup(projectId);


    // save
    result = plmProjectManager->saveProjectAs(projectId, type, path);
    IFOK(result) {
        m_projectsNotModifiedOnceList.removeAll(projectId);
        m_projectsNotSavedList.removeAll(projectId);

        if (isThisABackup) {
            emit projectIsBackupChanged(projectId, false);
        }

        emit projectSaved(projectId);
    }
    IFKO(result) {
        emit errorSent(result);
    }


    return result;
}

// ----------------------------------------------------------------------------

SKRResult PLMProjectHub::saveAProjectCopy(int            projectId,
                                          const QString& type,
                                          const QUrl   & path)
{
    SKRResult result(this);

    // firstly, save the project
    result = this->saveProjectAs(projectId, type, path);

    // then create a copy
    IFOK(result) {
        result = plmProjectManager->saveProjectAs(projectId, type, path, true);
    }


    IFKO(result) {
        emit errorSent(result);
    }

    return result;
}

// ----------------------------------------------------------------------------

SKRResult PLMProjectHub::backupAProject(int            projectId,
                                        const QString& type,
                                        const QUrl   & folderPath) {
    SKRResult result(this);

    QUrl projectPath = this->getPath(projectId);

    if (projectPath.isEmpty()) {
        result = SKRResult(SKRResult::Warning, this, "no_path");
        result.addData("projectId", projectId);
    }

    if (projectPath.scheme() == "qrc") {
        result = SKRResult(SKRResult::Warning, this, "qrc_projects_cant_back_up");
        result.addData("projectId", projectId);
    }


    IFOK(result) {
        // verify backup path
        QFileInfo folderInfo(folderPath.toLocalFile());

        if (!folderInfo.exists()) {
            result = SKRResult(SKRResult::Critical, this, "path_dont_exist");
            result.addData("projectId", projectId);
        }

        if (!folderInfo.isDir()) {
            result = SKRResult(SKRResult::Critical, this, "path_not_a_directory");
            result.addData("projectId", projectId);
        }

        if (!folderInfo.isWritable()) {
            result = SKRResult(SKRResult::Critical, this, "path_not_writable");
            result.addData("projectId", projectId);
        }
    }


    // determine file base
    QFileInfo info(projectPath.toLocalFile());
    QFileInfo backupFolderInfo(folderPath.toLocalFile());
    QString   backupFile = backupFolderInfo.filePath() + "/" + info.completeBaseName();

    // add date and time :
    QDateTime now     = QDateTime::currentDateTime();
    QString   nowText = now.toString("_yyyy-MM-dd-HHmmss");

    backupFile = backupFile + nowText;

    // add suffix :
    backupFile = backupFile + "." + type;

    // firstly, save the project
    IFOKDO(result, this->saveProject(projectId));

    // then create a copy
    IFOK(result) {
        result =
            plmProjectManager->saveProjectAs(projectId,
                                             type,
                                             QUrl::fromLocalFile(backupFile),
                                             true);
    }

    IFKO(result) {
        emit errorSent(result);
    }

    return result;
}

// ----------------------------------------------------------------------------

bool PLMProjectHub::doesBackupOfTheDayExistAtPath(int projectId, const QUrl& folderPath) {
    SKRResult result(this);

    QUrl projectPath = this->getPath(projectId);

    if (projectPath.isEmpty()) {
        result = SKRResult(SKRResult::Warning, this, "no_path");
        result.addData("projectId", projectId);
    }
    IFOK(result) {
        // verify backup path
        QFileInfo folderInfo(folderPath.toLocalFile());

        if (!folderInfo.exists()) {
            result = SKRResult(SKRResult::Critical, this, "path_dont_exist");
            result.addData("projectId", projectId);
        }

        if (!folderInfo.isDir()) {
            result = SKRResult(SKRResult::Critical, this, "path_not_a_directory");
            result.addData("projectId", projectId);
        }

        if (!folderInfo.isWritable()) {
            result = SKRResult(SKRResult::Critical, this, "path_not_writable");
            result.addData("projectId", projectId);
        }
    }
    IFKO(result) {
        emit errorSent(result);

        return true;
    }


    // determine file base
    QFileInfo info(projectPath.toLocalFile());
    QString   backupFileOfTheDay = info.completeBaseName();

    // add date and time :
    QDateTime now     = QDateTime::currentDateTime();
    QString   nowText = now.toString("_yyyy-MM-dd");

    backupFileOfTheDay = backupFileOfTheDay + nowText + "*";

    // find file begining with backupFileOfTheDay

    QDir dir(folderPath.toLocalFile());
    QStringList nameFilters;

    nameFilters << backupFileOfTheDay;
    QStringList entries = dir.entryList(nameFilters);

    if (entries.isEmpty()) {
        return false;
    }
    return true;
}

// ----------------------------------------------------------------------------

SKRResult PLMProjectHub::closeProject(int projectId)
{
    SKRResult result(this);

    m_isProjectToBeClosed = projectId;
    emit projectToBeClosed(projectId);

    result = plmProjectManager->closeProject(projectId);
    IFOK(result) {
        emit projectClosed(projectId);
        emit projectCountChanged(this->getProjectCount());

        if (isThereAnyLoadedProject()) {
            emit isThereAnyLoadedProjectChanged(true);
        }
        else {
            emit isThereAnyLoadedProjectChanged(false);
        }
        m_projectsNotModifiedOnceList.removeAll(projectId);
        m_projectsNotSavedList.removeAll(projectId);
        m_isProjectToBeClosed = -2;
    }

    IFKO(result) {
        m_isProjectToBeClosed = -2;
        emit errorSent(result);
    }

    return result;
}

// ----------------------------------------------------------------------------

SKRResult PLMProjectHub::closeAllProjects()
{
    SKRResult result(this);

    QList<int> idList = plmProjectManager->projectIdList();

    for (int id : idList) {
        IFOKDO(result, closeProject(id));
        IFKO(result) {
            break;
        }
    }

    IFOK(result) {
        emit allProjectsClosed();
    }

    IFKO(result) {
        emit errorSent(result);
    }

    return result;
}

// ----------------------------------------------------------------------------

bool PLMProjectHub::isProjectToBeClosed(int projectId) const
{
    return m_isProjectToBeClosed == projectId;
}

// ----------------------------------------------------------------------------


QList<int>PLMProjectHub::getProjectIdList()
{
    return plmProjectManager->projectIdList();
}

// ----------------------------------------------------------------------------

int PLMProjectHub::getProjectCount()
{
    return plmProjectManager->projectIdList().count();
}

// ----------------------------------------------------------------------------

QUrl PLMProjectHub::getPath(int projectId) const
{
    SKRResult result(this);
    QUrl url;
    PLMProject *project = plmProjectManager->project(projectId);

    if (!project) {
        result = SKRResult(SKRResult::Critical, this, "project_not_found");
        result.addData("projectId", projectId);
    }

    IFOK(result) {
        url = project->getPath();
    }
    IFKO(result) {
        // no project
        emit errorSent(result);
    }
    return url;
}

// ----------------------------------------------------------------------------

SKRResult PLMProjectHub::setPath(int projectId, const QUrl& newUrlPath)
{
    SKRResult   result(this);
    PLMProject *project = plmProjectManager->project(projectId);

    if (!project) {
        result = SKRResult(SKRResult::Critical, this, "project_not_found");
    }

    IFOKDO(result, project->setPath(newUrlPath))
    IFOK(result) {
        emit projectPathChanged(projectId, newUrlPath);
    }

    IFKO(result) {
        emit errorSent(result);
    }


    return result;
}

// ----------------------------------------------------------------------------

bool PLMProjectHub::isURLAlreadyLoaded(const QUrl& newUrlPath) {
    QList<int> list = plmProjectManager->projectIdList();

    for (int id : list) {
        if (newUrlPath == this->getPath(id)) {
            return true;
        }
    }
    return false;
}

// ----------------------------------------------------------------------------
int PLMProjectHub::getLastLoaded() const
{
    QList<int> list = plmProjectManager->projectIdList();
    int lastId      = -1;

    if (!list.isEmpty()) {
        lastId = list.last();
    }

    return lastId;
}

// ----------------------------------------------------------------------------

SKRResult PLMProjectHub::getError()
{
    return m_error;
}

bool PLMProjectHub::isThereAnyLoadedProject()
{
    QList<int> list = plmProjectManager->projectIdList();

    if (list.isEmpty()) {
        return false;
    }
    return true;
}

// ----------------------------------------------------------------------------

bool PLMProjectHub::isThisProjectABackup(int projectId)
{
    if (this->getPath(projectId).isEmpty()) {
        return false;
    }

    // search the date format in the file name :
    if (this->getPath(projectId).toLocalFile().contains(QRegularExpression(
                                                            "_\\d\\d\\d\\d-\\d\\d-\\d\\d-\\d\\d\\d\\d\\d\\d")))
    {
        return true;
    }
    return false;
}

// ----------------------------------------------------------------------------

QString PLMProjectHub::getProjectType(int projectId) const
{
    SKRResult   result(this);
    QString     value;
    PLMProject *project = plmProjectManager->project(projectId);

    if (!project) {
        result = SKRResult(SKRResult::Critical, this, "project_not_found");
    }

    IFOK(result) {
        value = project->getType();
    }
    IFKO(result) {
        // no project
        emit errorSent(result);
    }
    return value;
}

// ----------------------------------------------------------------------------

void PLMProjectHub::setActiveProject(int activeProject)
{
    m_activeProject = activeProject;

    emit activeProjectChanged(m_activeProject);
}

// ----------------------------------------------------------------------------

bool PLMProjectHub::isThisProjectActive(int projectId)
{
    return this->getActiveProject() == projectId;
}

// ----------------------------------------------------------------------------

int PLMProjectHub::getActiveProject()
{
    if (this->getProjectIdList().isEmpty()) {
        m_activeProject = -2;
    }
    else if (!this->getProjectIdList().contains(m_activeProject)) {
        m_activeProject = this->getProjectIdList().first();
    }

    if (this->getProjectIdList().count() == 1) {
        m_activeProject = this->getProjectIdList().first();
    }
    return m_activeProject;
}

// ----------------------------------------------------------------------------

void PLMProjectHub::setError(const SKRResult& result)
{
    m_error = result;
}

// ----------------------------------------------------------------------------

QString PLMProjectHub::getProjectName(int projectId) const {
    return get(projectId, "t_project_name").toString();
}

SKRResult PLMProjectHub::setProjectName(int projectId, const QString& projectName) {
    SKRResult result = this->set(projectId, "t_project_name", projectName, true);

    IFOK(result) {
        emit projectNameChanged(projectId, projectName);

        this->setProjectNotSavedAnymore(projectId);
    }
    IFKO(result) {
        emit errorSent(result);
    }
    return result;
}

// ----------------------------------------------------------------------------

QString PLMProjectHub::getLangCode(int projectId) const {
    return get(projectId, "t_spell_check_lang").toString();
}

SKRResult PLMProjectHub::setLangCode(int projectId, const QString& langCode) {
    SKRResult result = this->set(projectId, "t_spell_check_lang", langCode, true);

    IFOK(result) {
        emit langCodeChanged(projectId, langCode);

        this->setProjectNotSavedAnymore(projectId);
    }
    IFKO(result) {
        emit errorSent(result);
    }
    return result;
}

// ----------------------------------------------------------------------------

QString PLMProjectHub::getProjectUniqueId(int projectId) const
{
    return get(projectId, "t_project_unique_identifier").toString();
}

// ----------------------------------------------------------------------------

SKRResult PLMProjectHub::importPlumeCreatorProject(const QUrl& plumeURL, const QUrl& skribistoFileURL)
{
    PLMImporter importer;

    SKRResult result =  importer.importPlumeCreatorProject(plumeURL, skribistoFileURL);

    IFKO(result) {
        emit errorSent(result);
    }

    return result;
}

// ----------------------------------------------------------------------------

SKRResult PLMProjectHub::set(int             projectId,
                             const QString & fieldName,
                             const QVariant& value,
                             bool            setCurrentDateBool)
{
    SKRResult result(this);
    PLMSqlQueries queries(projectId, m_tableName);
    int id = 1;

    queries.beginTransaction();
    result = queries.set(id, fieldName, value);

    if (setCurrentDateBool) {
        IFOKDO(result, queries.setCurrentDate(id, "dt_updated"));
    }

    IFKO(result) {
        queries.rollback();
    }
    IFOK(result) {
        queries.commit();
    }
    IFKO(result) {
        emit errorSent(result);
    }
    return result;
}

QVariant PLMProjectHub::get(int projectId, const QString& fieldName) const
{
    SKRResult result(this);
    QVariant  var;
    QVariant  value;
    int id = 1;
    PLMSqlQueries queries(projectId, m_tableName);

    result = queries.get(id, fieldName, var);
    IFOK(result) {
        value = var;
    }
    IFKO(result) {
        emit errorSent(result);
    }
    return value;
}
