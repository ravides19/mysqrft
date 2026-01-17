# Mishka Chelekom CSS Configuration
#
# This file allows you to customize the CSS variables used by Mishka components.
# Uncomment and modify only the variables you want to override.
# Variable names use underscores instead of dashes (e.g., primary_light instead of --primary-light)

import Config

config :mishka_chelekom,
  # List of components to exclude from generation when using mix mishka.ui.gen.components
  # Example: ["alert", "badge", "button"]
  exclude_components: [],

  # Component attribute filters - limit which values are generated (reduces code size)
  # If empty or not specified, all values will be included

  # List of colors to include in component generation
  # Example: ["base", "primary", "danger", "success"]
  component_colors: [
    "white",
        "dark",
        "natural",
        "primary",
        "secondary",
        "success",
        "warning",
        "danger",
        "info",
        "misc",
        "dawn",
        "silver"
  ],

  # List of variants to include in component generation
  # Example: ["default", "outline", "bordered"]
  component_variants: ["default", "outline", "transparent", "bordered", "gradient", "shadow",],

  # List of sizes to include in component generation
  # Example: ["small", "medium", "large"]
  component_sizes: ["extra_small", "small", "medium", "large", "extra_large"],

  # List of rounded options to include in component generation
  # Example: ["small", "medium", "full"]
  component_rounded: ["extra_small", "small", "medium", "large", "extra_large", "full", "none"],

  # List of padding options to include in component generation
  # Example: ["small", "medium", "large"]
  component_padding: ["extra_small","small", "medium", "large", "extra_large", "none"],

  # List of space options to include in component generation
  # Example: ["small", "medium", "large", "none"]
  component_space: ["extra_small", "small", "medium", "large", "extra_large", "none"],

  # Override specific CSS variables (uncomment and modify as needed)
  # Property Management Portal - Airbnb-inspired color palette with red, wooden & rich tones
  css_overrides:
    %{
      # === Base Colors - Warmer tones for property portal ===
      base_border_light: "#e5e3e0",
      base_border_dark: "#2a2a28",
      base_text_light: "#1a1a18",
      base_text_dark: "#faf9f7",
      base_bg_dark: "#1a1815",
      base_hover_light: "#faf9f7",
      base_hover_dark: "#2a2724",
      base_disabled_bg_light: "#f5f3f0",
      base_text_hover_light: "#2a2724",
      base_text_hover_dark: "#f0ede8",
      base_disabled_bg_dark: "#2e2c29",
      base_disabled_text_light: "#a8a5a0",
      base_disabled_text_dark: "#6b6863",
      base_disabled_border_light: "#e0ddd8",
      base_disabled_border_dark: "#3e3c39",
      base_tab_bg_light: "#f8f5f0",

      # === Default Colors ===
      default_dark_bg: "#2a2724",
      default_light_gray: "#f8f5f0",
      default_gray: "#b8b5b0",
      ring_dark: "#1a1815",
      default_device_dark: "#3e3c39",
      range_light_gray: "#e8e5e0",

      # === Natural Theme - Wooden/earthy tones ===
      natural_light: "#6b5d52",
      natural_dark: "#d4c5b8",
      natural_hover_light: "#4a3e35",
      natural_hover_dark: "#e4d5c8",
      natural_bordered_hover_light: "#e4d5c8",
      natural_bordered_hover_dark: "#5a4d42",
      natural_bg_light: "#f5f1ed",
      natural_bg_dark: "#3e3530",
      natural_border_light: "#4a3e35",
      natural_border_dark: "#d4c5b8",
      natural_bordered_text_light: "#4a3e35",
      natural_bordered_text_dark: "#d4c5b8",
      natural_bordered_bg_light: "#f5f1ed",
      natural_bordered_bg_dark: "#3e3530",
      natural_disabled_light: "#c4b5a8",
      natural_disabled_dark: "#6b5d52",

      # === Primary Theme - Airbnb-style red (#FF385C) ===
      primary_light: "#FF385C",
      primary_dark: "#FF6B7A",
      primary_hover_light: "#E0304A",
      primary_hover_dark: "#FF8A96",
      primary_bordered_text_light: "#E0304A",
      primary_bordered_text_dark: "#FF8A96",
      primary_bordered_bg_light: "#FFF0F2",
      primary_bordered_bg_dark: "#3D0A12",
      primary_indicator_light: "#CC2C47",
      primary_indicator_dark: "#FFB4BC",
      primary_border_light: "#CC2C47",
      primary_border_dark: "#FFB4BC",
      primary_gradient_indicator_dark: "#FFD8DB",

      # === Secondary Theme - Rich warm brown/wooden ===
      secondary_light: "#8B5A3C",
      secondary_dark: "#C4926A",
      secondary_hover_light: "#6B4229",
      secondary_hover_dark: "#D4A378",
      secondary_bordered_text_light: "#6B4229",
      secondary_bordered_text_dark: "#D4A378",
      secondary_bordered_bg_light: "#FAF5F0",
      secondary_bordered_bg_dark: "#2A1A0F",
      secondary_indicator_light: "#6B4229",
      secondary_indicator_dark: "#E8C4A5",
      secondary_border_light: "#5A3520",
      secondary_border_dark: "#E8C4A5",
      secondary_gradient_indicator_dark: "#F2D9C4",

      # === Success Theme ===
      # success_light: "#0e8345",
      # success_dark: "#06c167",
      # success_hover_light: "#166c3b",
      # success_hover_dark: "#7fd99a",
      # success_bordered_text_light: "#166c3b",
      # success_bordered_text_dark: "#7fd99a",
      # success_bordered_bg_light: "#eaf6ed",
      # success_bordered_bg_dark: "#002f14",
      # success_indicator_light: "#047857",
      # success_indicator_alt_light: "#0d572d",
      # success_indicator_dark: "#b1eac2",
      # success_border_light: "#0d572d",
      # success_border_dark: "#b1eac2",
      # success_gradient_indicator_dark: "#d3efda",

      # === Warning Theme ===
      # warning_light: "#ca8d01",
      # warning_dark: "#fdc034",
      # warning_hover_light: "#976a01",
      # warning_hover_dark: "#fdd067",
      # warning_bordered_text_light: "#976a01",
      # warning_bordered_text_dark: "#fdd067",
      # warning_bordered_bg_light: "#fff7e6",
      # warning_bordered_bg_dark: "#322300",
      # warning_indicator_light: "#ff8b08",
      # warning_indicator_alt_light: "#654600",
      # warning_indicator_dark: "#fedf99",
      # warning_border_light: "#654600",
      # warning_border_dark: "#fedf99",
      # warning_gradient_indicator_dark: "#feefcc",

      # === Danger Theme ===
      # danger_light: "#de1135",
      # danger_dark: "#fc7f79",
      # danger_hover_light: "#bb032a",
      # danger_hover_dark: "#ffb2ab",
      # danger_bordered_text_light: "#bb032a",
      # danger_bordered_text_dark: "#ffb2ab",
      # danger_bordered_bg_light: "#fff0ee",
      # danger_bordered_bg_dark: "#520810",
      # danger_indicator_light: "#e73b3b",
      # danger_indicator_alt_light: "#950f22",
      # danger_indicator_dark: "#ffd2cd",
      # danger_border_light: "#950f22",
      # danger_border_dark: "#ffd2cd",
      # danger_gradient_indicator_dark: "#ffe1de",

      # === Info Theme ===
      # info_light: "#0b84ba",
      # info_dark: "#3eb7ed",
      # info_hover_light: "#08638c",
      # info_hover_dark: "#6ec9f2",
      # info_bordered_text_light: "#0b84ba",
      # info_bordered_text_dark: "#6ec9f2",
      # info_bordered_bg_light: "#e7f6fd",
      # info_bordered_bg_dark: "#03212f",
      # info_indicator_light: "#004fc4",
      # info_indicator_alt_light: "#06425d",
      # info_indicator_dark: "#9fdbf6",
      # info_border_light: "#06425d",
      # info_border_dark: "#9fdbf6",
      # info_gradient_indicator_dark: "#cfedfb",

      # === Misc Theme ===
      # misc_light: "#8750c5",
      # misc_dark: "#ba83f9",
      # misc_hover_light: "#653c94",
      # misc_hover_dark: "#cba2fa",
      # misc_bordered_text_light: "#653c94",
      # misc_bordered_text_dark: "#cba2fa",
      # misc_bordered_bg_light: "#f6f0fe",
      # misc_bordered_bg_dark: "#221431",
      # misc_indicator_light: "#52059c",
      # misc_indicator_alt_light: "#442863",
      # misc_indicator_dark: "#ddc1fc",
      # misc_border_light: "#442863",
      # misc_border_dark: "#ddc1fc",
      # misc_gradient_indicator_dark: "#eee0fd",

      # === Dawn Theme - Rich terracotta/warm earth ===
      dawn_light: "#B8623A",
      dawn_dark: "#E89A6B",
      dawn_hover_light: "#8B4A2A",
      dawn_hover_dark: "#F0A680",
      dawn_bordered_text_light: "#8B4A2A",
      dawn_bordered_text_dark: "#F0A680",
      dawn_bordered_bg_light: "#FFF5ED",
      dawn_bordered_bg_dark: "#2E1A0E",
      dawn_indicator_light: "#6B3E25",
      dawn_indicator_alt_light: "#5A321C",
      dawn_indicator_dark: "#F2C5A8",
      dawn_border_light: "#5A321C",
      dawn_border_dark: "#F2C5A8",
      dawn_gradient_indicator_dark: "#F8DCC4",

      # === Silver Theme ===
      # silver_light: "#868686",
      # silver_dark: "#a6a6a6",
      # silver_hover_light: "#727272",
      # silver_hover_dark: "#bbbbbb",
      # silver_hover_bordered_light: "#E8E8E8",
      # silver_hover_bordered_dark: "#5E5E5E",
      # silver_bordered_text_light: "#727272",
      # silver_bordered_text_dark: "#bbbbbb",
      # silver_bordered_bg_light: "#f3f3f3",
      # silver_bordered_bg_dark: "#4b4b4b",
      # silver_indicator_light: "#707483",
      # silver_indicator_alt_light: "#5e5e5e",
      # silver_indicator_dark: "#dddddd",
      # silver_border_light: "#5e5e5e",
      # silver_border_dark: "#dddddd",

      # === Borders & States ===
      # bordered_white_border: "#dddddd",
      # bordered_dark_bg: "#282828",
      # bordered_dark_border: "#727272",
      # disabled_bg_light: "#f3f3f3",
      # disabled_bg_dark: "#4b4b4b",
      # disabled_text_light: "#bbbbbb",
      # disabled_text_dark: "#868686",

      # === Shadows - Updated for property portal colors ===
      shadow_natural: "rgba(107, 93, 82, 0.5)",
      shadow_primary: "rgba(255, 56, 92, 0.5)",
      shadow_secondary: "rgba(139, 90, 60, 0.5)",
      shadow_success: "rgba(0, 154, 81, 0.5)",
      shadow_warning: "rgba(252, 176, 1, 0.5)",
      shadow_danger: "rgba(222, 17, 53, 0.5)",
      shadow_info: "rgba(14, 165, 233, 0.5)",
      shadow_misc: "rgba(169, 100, 247, 0.5)",
      shadow_dawn: "rgba(184, 98, 58, 0.5)",
      shadow_silver: "rgba(134, 134, 134, 0.5)",

      # === Gradients - Property portal inspired ===
      gradient_natural_from_light: "#4a3e35",
      gradient_natural_to_light: "#6b5d52",
      gradient_natural_from_dark: "#b8a899",
      gradient_primary_from_light: "#E0304A",
      gradient_primary_to_light: "#FF385C",
      gradient_primary_from_dark: "#FF385C",
      gradient_primary_to_dark: "#FFB4BC",
      gradient_secondary_from_light: "#6B4229",
      gradient_secondary_to_light: "#8B5A3C",
      gradient_secondary_from_dark: "#C4926A",
      gradient_secondary_to_dark: "#E8C4A5",
      # gradient_success_from_light: "#166c3b",
      # gradient_success_to_light: "#06c167",
      # gradient_success_from_dark: "#06c167",
      # gradient_success_to_dark: "#b1eac2",
      # gradient_warning_from_light: "#976a01",
      # gradient_warning_to_light: "#fdc034",
      # gradient_warning_from_dark: "#fdc034",
      # gradient_warning_to_dark: "#fedf99",
      # gradient_danger_from_light: "#bb032a",
      # gradient_danger_to_light: "#fc7f79",
      # gradient_danger_from_dark: "#fc7f79",
      # gradient_danger_to_dark: "#ffd2cd",
      # gradient_info_from_light: "#08638c",
      # gradient_info_to_light: "#3eb7ed",
      # gradient_info_from_dark: "#3eb7ed",
      # gradient_info_to_dark: "#9fdbf6",
      # gradient_misc_from_light: "#653c94",
      # gradient_misc_to_light: "#ba83f9",
      # gradient_misc_from_dark: "#ba83f9",
      # gradient_misc_to_dark: "#ddc1fc",
      gradient_dawn_from_light: "#8B4A2A",
      gradient_dawn_to_light: "#B8623A",
      gradient_dawn_from_dark: "#E89A6B",
      gradient_dawn_to_dark: "#F2C5A8",
      # gradient_silver_from_light: "#5e5e5e",
      # gradient_silver_to_light: "#a6a6a6",
      # gradient_silver_from_dark: "#868686",
      # gradient_silver_to_dark: "#bbbbbb",

      # === Form Elements ===
      # base_form_border_light: "#8b8b8d",
      # base_form_border_dark: "#818182",
      # base_form_focus_dark: "#696969",
      # form_white_text: "#3e3e3e",
      # form_white_focus: "#dadada",

      # === Checkbox Colors ===
      checkbox_unchecked_dark: "#3e3c39",
      checkbox_white_checked: "#f0ede8",
      checkbox_dark_checked: "#6b6863",
      checkbox_primary_checked: "#FF385C",
      checkbox_secondary_checked: "#8B5A3C",
      checkbox_success_checked: "#009a51",
      checkbox_warning_checked: "#fcb001",
      checkbox_danger_checked: "#E0304A",
      checkbox_info_checked: "#0ea5e9",
      checkbox_misc_checked: "#a964f7",
      checkbox_dawn_checked: "#B8623A",
      checkbox_silver_checked: "#a6a6a6",

      # === Stepper Colors ===
      # stepper_loading_icon_fill: "#2563eb",
      # stepper_current_step_text_light: "#2563eb",
      # stepper_current_step_text_dark: "#1971c2",
      # stepper_current_step_border_light: "#2563eb",
      # stepper_current_step_border_dark: "#1971c2",
      # stepper_completed_step_bg_light: "#14b8a6",
      # stepper_completed_step_bg_dark: "#099268",
      # stepper_completed_step_border_light: "#14b8a6",
      # stepper_completed_step_border_dark: "#099268",
      # stepper_canceled_step_bg_light: "#fa5252",
      # stepper_canceled_step_bg_dark: "#e03131",
      # stepper_canceled_step_border_light: "#fa5252",
      # stepper_canceled_step_border_dark: "#e03131",
      # stepper_separator_completed_border_light: "#14b8a6",
      # stepper_separator_completed_border_dark: "#099268"
    },

  # Strategy for handling CSS
  # :merge - Merge overrides with defaults (recommended)
  # :replace - Completely replace with custom CSS file
  css_merge_strategy: :merge,

  # Path to custom CSS file (only used when css_merge_strategy is :replace)
  # custom_css_path: "priv/static/css/custom_mishka.css"
  custom_css_path: nil
