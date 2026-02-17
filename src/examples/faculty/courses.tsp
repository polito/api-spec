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

const _ex_listAssignmentCollaborators_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{
          personId: "p002",
          name: "Luigi Verdi",
          role: "Teaching Assistant",
          courses: #["251007", "252121"],
          permissions: #["CAN_READ", "CAN_EDIT"],
        },
        #{
          personId: "p003",
          name: "Anna Bianchi",
          role: "Tutor",
          courses: #["251007"],
          permissions: #["CAN_READ"],
        }
      ],
    },
  },
};
