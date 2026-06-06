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
  returnType: #{ statusCode: 204 },
};

const _ex_updateCourseFolder_resp = #{
  parameters: #{
    courseId: 251007,
    folderId: "33352562",
    body: #{ name: "Laboratori 2024" },
  },
  returnType: #{ statusCode: 204 },
};

const _ex_updateCourseFile_resp = #{
  parameters: #{
    courseId: 251007,
    fileId: "2",
    body: #{ name: "Lecture1_rev.pdf", parentId: "33352562" },
  },
  returnType: #{ statusCode: 204 },
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
          email: "s123456@studenti.polito.it",
          picture: #{ url: "https://didattica.polito.it/photos/s123456.jpg" },
        },
        #{
          id: "s234567",
          firstName: "Luigi",
          lastName: "Verdi",
          username: "s234567",
          email: "s234567@studenti.polito.it",
          picture: #{ url: "https://didattica.polito.it/photos/s234567.jpg" },
        }
      ],
    },
  },
};

const _ex_searchEnrollableStudents_resp = #{
  parameters: #{ courseId: 251007, search: "Federica" },
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{
          id: "s123456",
          firstName: "Federica",
          lastName: "Bianchi",
          username: "s123456",
          email: "s123456@studenti.polito.it",
          picture: #{ url: "https://didattica.polito.it/photos/s123456.jpg" },
        },
        #{
          id: "s123457",
          firstName: "Federica",
          lastName: "Rossi",
          username: "s123457",
          email: "s123457@studenti.polito.it",
          picture: #{ url: "https://didattica.polito.it/photos/s123457.jpg" },
        },
        #{
          id: "s123458",
          firstName: "Federica",
          lastName: "Verdi",
          username: "s123458",
          email: "s123458@studenti.polito.it",
          picture: #{ url: "https://didattica.polito.it/photos/s123458.jpg" },
        }
      ],
    },
  },
};

const _ex_enrollStudents_resp = #{
  parameters: #{
    courseId: 251007,
    body: #{ studentIds: #["s123456", "s123458"] },
  },
  returnType: #{ statusCode: 204 },
};

const _ex_getCourseStudentsStats_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        totalEnrolled: 204,
        withAttendanceIssues: 10,
        tookExam: 0,
        withExamDebts: 42,
        eligibleForExam: 194,
        firstTimeInAcademicYear: 152,
      },
    },
  },
};

const _ex_getFacultyCourseStudent_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        id: "s123456",
        firstName: "Stefania",
        lastName: "Sassi",
        username: "s123456",
        email: "s123456@studenti.polito.it",
        picture: #{ url: "https://didattica.polito.it/photos/s123456.jpg" },
        course: #{ shortcode: "02JSKPD", cfu: 6 },
        degreeCode: "CINZT3",
        degreeName: "COMPUTER ENGINEERING",
        examResult: #{ date: plainDate.fromISO("2025-02-23"), grade: "30L" },
        subscription: "2025/2026",
        citizenship: "Italian",
        hasSpecialNeeds: true,
      },
    },
  },
};

const _ex_getCourseStudentSpecialNeeds_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        content: "<p>List of compensatory measures granted to Stefania Sassi</p><ul><li><b>Calculator</b> allowed</li><li><b>Readability criteria</b> (Arial, 12-point font, 1.5 line spacing, non-justified text, expanded spacing)</li><li><b>Cheat sheet for formulas</b> for written and oral exams</li><li><b>30% additional time for completing exams</b></li><li><b>Assessment of content vs. form</b></li></ul>",
        moreDetailsUrl: "https://didattica.polito.it/special-needs/requests?courseId=251007",
        handbook: #{
          name: "Reporting procedure handbook",
          url: "https://didattica.polito.it/docs/reporting-procedure-handbook.pdf",
        },
      },
    },
  },
};
