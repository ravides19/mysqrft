defmodule MySqrftWeb.Storybook do
  use PhoenixStorybook,
    otp_app: :my_sqrft,
    content_path: Path.expand("../../storybook", __DIR__),
    # assets path are remote path, not local file-system paths
    css_path: "/assets/storybook.css",
    js_path: "/assets/js/storybook.js",
    sandbox_class: "my-sqrft"
end
