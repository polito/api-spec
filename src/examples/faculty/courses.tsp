namespace PolitoAPI;

const _ex_createCourseNotice_req = #{
  parameters: #{
    courseId: 251007,
    body: #{
      isDraft: false,
      content: "<p>Lezione di domani spostata in aula 7T.</p>",
      visibleFrom: utcDateTime.fromISO("2025-10-14T09:00:00Z"),
      visibleUntil: utcDateTime.fromISO("2025-10-20T23:59:59Z"),
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
      visibleFrom: utcDateTime.fromISO("2025-10-14T09:00:00Z"),
      visibleUntil: utcDateTime.fromISO("2025-10-22T23:59:59Z"),
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
    folderId: "33248655",
    body: #{ name: "videolectures 2026" },
  },
  returnType: #{ statusCode: 204 },
};

const _ex_updateCourseFile_resp = #{
  parameters: #{
    courseId: 251007,
    fileId: "33248890",
    body: #{ name: "HCI2021-L01_rev.m4v", parentId: "33248655" },
  },
  returnType: #{ statusCode: 204 },
};

const _ex_moveCourseItems_resp = #{
  parameters: #{
    courseId: 251007,
    body: #{ itemIds: #["33248890", "33251708"], destinationFolderId: null },
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
          id: 123456,
          firstName: "Stefania",
          lastName: "Sassi",
          username: "s123456",
          email: "s123456@studenti.polito.it",
          picture: #{ url: "https://didattica.polito.it/photos/s123456.jpg" },
        },
        #{
          id: 234567,
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
          id: 345670,
          firstName: "Federica",
          lastName: "Bianchi",
          username: "s345670",
          email: "s345670@studenti.polito.it",
          picture: #{ url: "https://didattica.polito.it/photos/s345670.jpg" },
        },
        #{
          id: 345671,
          firstName: "Federica",
          lastName: "Rossi",
          username: "s345671",
          email: "s345671@studenti.polito.it",
          picture: #{ url: "https://didattica.polito.it/photos/s345671.jpg" },
        },
        #{
          id: 345672,
          firstName: "Federica",
          lastName: "Verdi",
          username: "s345672",
          email: "s345672@studenti.polito.it",
          picture: #{ url: "https://didattica.polito.it/photos/s345672.jpg" },
        }
      ],
    },
  },
};

const _ex_enrollStudents_resp = #{
  parameters: #{ courseId: 251007, body: #{ studentIds: #[345670, 345672] } },
  returnType: #{ statusCode: 204 },
};

const _ex_sendStudentsMessage_resp = #{
  parameters: #{
    courseId: 251007,
    body: #{
      studentIds: #[123456, 234567, 345670],
      channel: MessageChannel.email,
      title: "Lezione di recupero",
      message: "Si avvisano gli studenti che la lezione di recupero si terrà venerdì alle 14:00 in aula 7T.",
    },
  },
  returnType: #{ statusCode: 202, body: #{ message: "Message accepted" } },
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
        id: 123456,
        firstName: "Stefania",
        lastName: "Sassi",
        username: "s123456",
        email: "s123456@studenti.polito.it",
        picture: #{ url: "https://didattica.polito.it/photos/s123456.jpg" },
        course: #{ shortcode: "02JSKPD", cfu: 6 },
        degreeCode: "CINZT3",
        degreeName: "COMPUTER ENGINEERING",
        examResult: #{ date: plainDate.fromISO("2026-02-23"), grade: "30L" },
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

const _ex_listFacultyCourseAssignments_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{
          id: 947503,
          filename: "PresentationGroup03.zip",
          student: #{ id: 348759, firstName: "Giuliana", lastName: "Annone" },
          status: FacultyAssignmentStatus.new,
          isRemovalRequested: false,
        },
        #{
          id: 947502,
          filename: "PresentationGroup02.zip",
          student: #{ id: 345658, firstName: "Lorenzo", lastName: "Ciovenco" },
          status: FacultyAssignmentStatus.seen,
          isRemovalRequested: false,
        },
        #{
          id: 947501,
          filename: "PresentationGroup01.zip",
          student: #{ id: 345600, firstName: "Marco", lastName: "Bruno" },
          status: FacultyAssignmentStatus.new,
          isRemovalRequested: true,
        }
      ],
    },
  },
};

const _ex_getFacultyCourseAssignment_resp = #{
  parameters: #{ courseId: 251007, assignmentId: 947503 },
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        id: 947503,
        description: "A presentation on advanced robotics and automation. Group 03.",
        mimeType: "application/x-zip-compressed",
        filename: "PresentationGroup03.zip",
        uploadedAt: utcDateTime.fromISO("2025-11-17T14:00:00Z"),
        deletedAt: null,
        url: "https://file.didattica.polito.it/down/ELABORATI_PRE/947503/S348759/6791f0016c78599138828211522fa84d/62cebc94",
        sizeInKiloBytes: 305,
        student: #{ id: 348759, firstName: "Giuliana", lastName: "Annone" },
        status: FacultyAssignmentStatus.new,
        isRemovalRequested: false,
      },
    },
  },
};

const _ex_answerCourseAssignment_resp = #{
  parameters: #{
    courseId: 251007,
    assignmentId: 947503,
    body: #{
      message: "Dear student, I cannot open the file you uploaded. Please try again to upload the folder in another format. Thank you!",
    },
  },
  returnType: #{ statusCode: 202, body: #{ message: "Answer accepted" } },
};
