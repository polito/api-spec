import "@typespec/http";

using Http;

namespace PolitoAPI;

model ThemeColors {
  /** Color used in light mode. */
  light: string;

  /** Color used in dark mode. */
  dark: string;
}

alias Color = string | ThemeColors;

@example(#{ color: "#000095", icon: "graduation-cap" })
model Symbol {
  label?: string;
  color?: Color;
  icon?: string;
}
