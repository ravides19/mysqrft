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
      base_text_light: "#332A20",
      base_text_medium_light: "#4A4A4A",
      base_text_dark: "#faf9f7",
      base_bg_dark: "#1a1815",
      base_hover_light: "#FAF9F7",
      base_hover_dark: "#2a2724",
      base_disabled_bg_light: "#f5f3f0",
      base_text_hover_light: "#2a2724",
      base_text_hover_dark: "#f0ede8",
      base_disabled_bg_dark: "#2e2c29",
      base_disabled_text_light: "#a8a5a0",
      base_disabled_text_dark: "#6b6863",
      base_disabled_border_light: "#e0ddd8",
      base_disabled_border_dark: "#3e3c39",
      base_tab_bg_light: "#F8F5F0",

      # === Default Colors ===
      default_dark_bg: "#2a2724",
      default_light_gray: "#F8F5F0",
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

      # === Secondary Theme - Rich warm brown/wooden (#805A3A from property ads) ===
      secondary_light: "#805A3A",
      secondary_dark: "#C4926A",
      secondary_hover_light: "#6B4229",
      secondary_hover_dark: "#D4A378",
      secondary_bordered_text_light: "#6B4229",
      secondary_bordered_text_dark: "#D4A378",
      secondary_bordered_bg_light: "#F8F5F0",
      secondary_bordered_bg_dark: "#2A1A0F",
      secondary_indicator_light: "#5A3520",
      secondary_indicator_dark: "#E8C4A5",
      secondary_border_light: "#5A3520",
      secondary_border_dark: "#E8C4A5",
      secondary_gradient_indicator_dark: "#F2D9C4",

      # === Success Theme - Forest Green (#388E3C from Mishika) ===
      success_light: "#388E3C",
      success_dark: "#4CAF50",
      success_hover_light: "#2E7D32",
      success_hover_dark: "#66BB6A",
      success_bordered_text_light: "#2E7D32",
      success_bordered_text_dark: "#66BB6A",
      success_bordered_bg_light: "#E8F5E9",
      success_bordered_bg_dark: "#1B3E1C",
      success_indicator_light: "#1B5E20",
      success_indicator_alt_light: "#1B5E20",
      success_indicator_dark: "#A5D6A7",
      success_border_light: "#1B5E20",
      success_border_dark: "#A5D6A7",
      success_gradient_indicator_dark: "#C8E6C9",

      # === Warning Theme - Golden Mustard (#D4A017 from Mishika) ===
      warning_light: "#D4A017",
      warning_dark: "#FFC107",
      warning_hover_light: "#B8860B",
      warning_hover_dark: "#FFD54F",
      warning_bordered_text_light: "#B8860B",
      warning_bordered_text_dark: "#FFD54F",
      warning_bordered_bg_light: "#FFF9E6",
      warning_bordered_bg_dark: "#3D2F00",
      warning_indicator_light: "#856404",
      warning_indicator_alt_light: "#856404",
      warning_indicator_dark: "#FFE082",
      warning_border_light: "#856404",
      warning_border_dark: "#FFE082",
      warning_gradient_indicator_dark: "#FFF59D",

      # === Danger Theme - Deep Red (Refined to #B71C1C for better differentiation from Primary) ===
      danger_light: "#B71C1C",
      danger_dark: "#EF5350",
      danger_hover_light: "#9A1515",
      danger_hover_dark: "#F57373",
      danger_bordered_text_light: "#B71C1C",
      danger_bordered_text_dark: "#F57373",
      danger_bordered_bg_light: "#FFEBEE",
      danger_bordered_bg_dark: "#4A0E0E",
      danger_indicator_light: "#7A0F0F",
      danger_indicator_alt_light: "#7A0F0F",
      danger_indicator_dark: "#FFCDD2",
      danger_border_light: "#7A0F0F",
      danger_border_dark: "#FFCDD2",
      danger_gradient_indicator_dark: "#FFCDD2",

      # === Info Theme - Medium Blue (#3F51B5 from Mishika) ===
      info_light: "#3F51B5",
      info_dark: "#5C6BC0",
      info_hover_light: "#303F9F",
      info_hover_dark: "#7986CB",
      info_bordered_text_light: "#303F9F",
      info_bordered_text_dark: "#7986CB",
      info_bordered_bg_light: "#E8EAF6",
      info_bordered_bg_dark: "#1A237E",
      info_indicator_light: "#1A237E",
      info_indicator_alt_light: "#1A237E",
      info_indicator_dark: "#9FA8DA",
      info_border_light: "#1A237E",
      info_border_dark: "#9FA8DA",
      info_gradient_indicator_dark: "#C5CAE9",

      # === Misc Theme - Purple (#673AB7 from Mishika) ===
      misc_light: "#673AB7",
      misc_dark: "#9575CD",
      misc_hover_light: "#5E35B1",
      misc_hover_dark: "#B39DDB",
      misc_bordered_text_light: "#5E35B1",
      misc_bordered_text_dark: "#B39DDB",
      misc_bordered_bg_light: "#F3E5F5",
      misc_bordered_bg_dark: "#311B92",
      misc_indicator_light: "#4527A0",
      misc_indicator_alt_light: "#4527A0",
      misc_indicator_dark: "#CE93D8",
      misc_border_light: "#4527A0",
      misc_border_dark: "#CE93D8",
      misc_gradient_indicator_dark: "#E1BEE7",

      # === Dawn Theme - Terracotta/Orange (#E8A06A from property ads) ===
      dawn_light: "#E8A06A",
      dawn_dark: "#F4B896",
      dawn_hover_light: "#D4834A",
      dawn_hover_dark: "#FFC5A3",
      dawn_bordered_text_light: "#D4834A",
      dawn_bordered_text_dark: "#FFC5A3",
      dawn_bordered_bg_light: "#FFF5ED",
      dawn_bordered_bg_dark: "#3D2415",
      dawn_indicator_light: "#A86438",
      dawn_indicator_alt_light: "#A86438",
      dawn_indicator_dark: "#F8DCC4",
      dawn_border_light: "#A86438",
      dawn_border_dark: "#F8DCC4",
      dawn_gradient_indicator_dark: "#FFE0CC",

      # === Silver Theme - Medium Gray (#757575 from Mishika) ===
      silver_light: "#757575",
      silver_dark: "#9E9E9E",
      silver_hover_light: "#616161",
      silver_hover_dark: "#BDBDBD",
      silver_hover_bordered_light: "#E0E0E0",
      silver_hover_bordered_dark: "#616161",
      silver_bordered_text_light: "#616161",
      silver_bordered_text_dark: "#BDBDBD",
      silver_bordered_bg_light: "#F5F5F5",
      silver_bordered_bg_dark: "#424242",
      silver_indicator_light: "#424242",
      silver_indicator_alt_light: "#424242",
      silver_indicator_dark: "#E0E0E0",
      silver_border_light: "#424242",
      silver_border_dark: "#E0E0E0",

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
      shadow_secondary: "rgba(128, 90, 58, 0.5)",
      shadow_success: "rgba(56, 142, 60, 0.5)",
      shadow_warning: "rgba(212, 160, 23, 0.5)",
      shadow_danger: "rgba(183, 28, 28, 0.5)",
      shadow_info: "rgba(63, 81, 181, 0.5)",
      shadow_misc: "rgba(103, 58, 183, 0.5)",
      shadow_dawn: "rgba(232, 160, 106, 0.5)",
      shadow_silver: "rgba(117, 117, 117, 0.5)",

      # === Gradients - Property portal inspired ===
      gradient_natural_from_light: "#4a3e35",
      gradient_natural_to_light: "#6b5d52",
      gradient_natural_from_dark: "#b8a899",
      gradient_primary_from_light: "#E0304A",
      gradient_primary_to_light: "#FF385C",
      gradient_primary_from_dark: "#FF385C",
      gradient_primary_to_dark: "#FFB4BC",
      gradient_secondary_from_light: "#6B4229",
      gradient_secondary_to_light: "#805A3A",
      gradient_secondary_from_dark: "#C4926A",
      gradient_secondary_to_dark: "#E8C4A5",
      gradient_success_from_light: "#2E7D32",
      gradient_success_to_light: "#388E3C",
      gradient_success_from_dark: "#4CAF50",
      gradient_success_to_dark: "#81C784",
      gradient_warning_from_light: "#B8860B",
      gradient_warning_to_light: "#D4A017",
      gradient_warning_from_dark: "#FFC107",
      gradient_warning_to_dark: "#FFE082",
      gradient_danger_from_light: "#9A1515",
      gradient_danger_to_light: "#B71C1C",
      gradient_danger_from_dark: "#EF5350",
      gradient_danger_to_dark: "#FFCDD2",
      gradient_info_from_light: "#303F9F",
      gradient_info_to_light: "#3F51B5",
      gradient_info_from_dark: "#5C6BC0",
      gradient_info_to_dark: "#9FA8DA",
      gradient_misc_from_light: "#4527A0",
      gradient_misc_to_light: "#673AB7",
      gradient_misc_from_dark: "#9575CD",
      gradient_misc_to_dark: "#CE93D8",
      gradient_dawn_from_light: "#D4834A",
      gradient_dawn_to_light: "#E8A06A",
      gradient_dawn_from_dark: "#F4B896",
      gradient_dawn_to_dark: "#FFC5A3",
      gradient_silver_from_light: "#616161",
      gradient_silver_to_light: "#757575",
      gradient_silver_from_dark: "#9E9E9E",
      gradient_silver_to_dark: "#BDBDBD",

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
      checkbox_secondary_checked: "#805A3A",
      checkbox_success_checked: "#388E3C",
      checkbox_warning_checked: "#D4A017",
      checkbox_danger_checked: "#B71C1C",
      checkbox_info_checked: "#3F51B5",
      checkbox_misc_checked: "#673AB7",
      checkbox_dawn_checked: "#E8A06A",
      checkbox_silver_checked: "#757575",

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
