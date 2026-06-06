const _ex_publishCourseNotice_req = #{
  parameters: #{
    courseId: 251007,
    isDraft: false,
    body: #{
      content: "<p>Lezione di domani spostata in aula 7T.</p>",
      publishedDate: utcDateTime.fromISO("2025-10-14T09:00:00Z"),
      expiresAt: utcDateTime.fromISO("2025-10-20T23:59:59Z"),
      isAlwaysVisible: true,
    },
  },
  returnType: #{ statusCode: 204 },
};

const _ex_updateCourseNotice_resp = #{
  parameters: #{
    courseId: 251007,
    noticeId: 360724,
    body: #{
      content: "<p>Aggiornamento: lezione spostata in aula 10T.</p>",
      publishedDate: utcDateTime.fromISO("2025-10-14T09:00:00Z"),
      expiresAt: utcDateTime.fromISO("2025-10-22T23:59:59Z"),
      isAlwaysVisible: false,
    },
  },
  returnType: #{ statusCode: 204 },
};

const _ex_createCourseFolder_resp = #{
  parameters: #{
    courseId: 251007,
    body: #{ name: "Laboratori", parentId: null },
  },
  returnType: #{
    statusCode: 201,
    body: #{
      data: #{
        type: "directory",
        id: "33352562",
        name: "Laboratori",
        files: #[],
      },
    },
  },
};

const _ex_updateCourseFolder_resp = #{
  parameters: #{
    courseId: 251007,
    folderId: "33352562",
    body: #{ name: "Laboratori 2024" },
  },
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        type: "directory",
        id: "33352562",
        name: "Laboratori 2024",
        files: #[],
      },
    },
  },
};

const _ex_updateCourseFile_resp = #{
  parameters: #{
    courseId: 251007,
    fileId: "2",
    body: #{ name: "Lecture1_rev.pdf", parentId: "33352562" },
  },
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        type: "file",
        id: "2",
        name: "Lecture1_rev.pdf",
        sizeInKiloBytes: 2048,
        mimeType: "application/pdf",
        createdAt: utcDateTime.fromISO("2024-06-01T10:00:00Z"),
        checksum: "deadbeefcafebabe0000000000000000",
      },
    },
  },
};

const _ex_moveCourseItems_resp = #{
  parameters: #{
    courseId: 251007,
    body: #{ itemIds: #["2", "33352562"], destinationFolderId: "44463673" },
  },
  returnType: #{ statusCode: 204 },
};

const _ex_deleteCourseNotice_resp = #{
  parameters: #{ courseId: 251007, noticeId: 360724 },
  returnType: #{ statusCode: 204 },
};

const _ex_listFacultyCourseStudents_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{
          id: "s123456",
          firstName: "Mario",
          lastName: "Rossi",
          username: "s123456",
          picture: #{ url: "https://didattica.polito.it/photos/s123456.jpg" },
        },
        #{
          id: "s234567",
          firstName: "Luigi",
          lastName: "Verdi",
          username: "s234567",
          picture: #{ url: "https://didattica.polito.it/photos/s234567.jpg" },
        }
      ],
    },
  },
};
