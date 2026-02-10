import "@typespec/http";

using Http;

namespace PolitoAPI;

const _ex_esc_delete_err = #{
  returnType: #{
    statusCode: 500,
    body: #{
      code: 500,
      message: "An error occurred",
      errors: #[#{ code: 500, message: "An error occurred", careerId: 123456 }],
    },
  },
};
