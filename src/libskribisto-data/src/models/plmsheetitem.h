/***************************************************************************
*   Copyright (C) 2019 by Cyril Jacquet                                 *
*   cyril.jacquet@skribisto.eu                                        *
*                                                                         *
*  Filename: plmsheetitem.h                                                   *
*  This file is part of Skribisto.                                    *
*                                                                         *
*  Skribisto is free software: you can redistribute it and/or modify  *
*  it under the terms of the GNU General Public License as published by   *
*  the Free Software Foundation, either version 3 of the License, or      *
*  (at your option) any later version.                                    *
*                                                                         *
*  Skribisto is distributed in the hope that it will be useful,       *
*  but WITHOUT ANY WARRANTY; without even the implied warranty of         *
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          *
*  GNU General Public License for more details.                           *
*                                                                         *
*  You should have received a copy of the GNU General Public License      *
*  along with Skribisto.  If not, see <http://www.gnu.org/licenses/>. *
***************************************************************************/
#ifndef PLMSHEETITEM_H
#define PLMSHEETITEM_H

// #include "plmsheetmodel.h"

#include <QtCore>
#include <QObject>
#include "./skribisto_data_global.h"

class EXPORT PLMSheetItem : public QObject {
    Q_OBJECT

public:

    enum Roles {
        // papers :
        ProjectNameRole  = Qt::UserRole,
        ProjectIdRole    = Qt::UserRole + 1,
        PaperIdRole      = Qt::UserRole + 2,
        NameRole         = Qt::UserRole + 3,
        LabelRole          = Qt::UserRole + 4,
        IndentRole       = Qt::UserRole + 5,
        SortOrderRole    = Qt::UserRole + 6,
        TrashedRole      = Qt::UserRole + 7,
        CreationDateRole = Qt::UserRole + 8,
        UpdateDateRole   = Qt::UserRole + 9,
        ContentDateRole  = Qt::UserRole + 10,
        HasChildrenRole  = Qt::UserRole + 11,
        ProjectIsBackupRole = Qt::UserRole + 12,
        ProjectIsActiveRole = Qt::UserRole + 13,

        // specific to sheets:
        CharCountRole = Qt::UserRole + 14,
        WordCountRole = Qt::UserRole + 15,
        SynopsisNoteIdRole = Qt::UserRole + 16


    };
    Q_ENUM(Roles)

    explicit PLMSheetItem();
    explicit PLMSheetItem(int projectId,
                          int paperId,
                          int indent,
                          int sortOrder);
    ~PLMSheetItem();

    void          invalidateData(int role);
    void          invalidateAllData();

    int           projectId();

    int           paperId();
    int           sortOrder();
    int           indent();
    Q_INVOKABLE QString       name();

    QVariant      data(int role);
    QList<int>    dataRoles() const;

    PLMSheetItem* parent(const QList<PLMSheetItem *>& itemList);
    int           row(const QList<PLMSheetItem *>& itemList);

    bool          isProjectItem() const;
    void          setIsProjectItem(int projectId);

    int           childrenCount(const QList<PLMSheetItem *>& itemList);
    PLMSheetItem* child(const QList<PLMSheetItem *>& itemList,
                        int                          row);
    bool          isRootItem() const;
    void          setIsRootItem();

signals:

public slots:

private:

    QHash<int, QVariant>m_data;
    QList<int> m_invalidatedRoles;
    bool m_isProjectItem, m_isRootItem;
};

#endif // PLMSHEETITEM_H
