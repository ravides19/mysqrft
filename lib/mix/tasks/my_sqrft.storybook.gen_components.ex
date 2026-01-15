defmodule Mix.Tasks.MySqrft.Storybook.GenComponents do
  @shortdoc "Generates Phoenix Storybook stories for MySqrft function components"

  use Mix.Task

  @moduledoc """
  Generates `*.story.exs` files under `storybook/components/**` for each component module found in
  `lib/my_sqrft_web/components/*.ex`.

  It generates one story per **function component** (arity 1) found in `module.__components__/0`,
  and auto-builds a default variation that attempts to populate **all params**.
  """

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("app.start")

    components_dir = Path.join(File.cwd!(), "lib/my_sqrft_web/components")
    storybook_dir = Path.join(File.cwd!(), "storybook/components")

    File.mkdir_p!(storybook_dir)

    components_dir
    |> File.ls!()
    |> Enum.filter(&String.ends_with?(&1, ".ex"))
    |> Enum.map(&Path.rootname/1)
    |> Enum.each(fn base ->
      module =
        case base do
          "layouts" -> MySqrftWeb.Layouts
          _ -> Module.concat([MySqrftWeb, Components, Macro.camelize(base)])
        end

      if Code.ensure_loaded?(module) and function_exported?(module, :__components__, 0) do
        generate_module_stories(storybook_dir, base, module)
      end
    end)
  end

  defp generate_module_stories(storybook_dir, base, module) do
    module_dir = Path.join(storybook_dir, base)
    File.mkdir_p!(module_dir)

    module
    |> module_component_funs()
    |> Enum.each(fn fun_name ->
      story_module = story_module_name(base, fun_name)
      story_path = Path.join(module_dir, "#{fun_name}.story.exs")
      File.write!(story_path, story_source(story_module, module, fun_name))
    end)
  end

  defp module_component_funs(module) do
    module.__components__()
    |> Map.keys()
    |> Enum.reject(&(&1 == :render))
    |> Enum.filter(&function_exported?(module, &1, 1))
    |> Enum.sort()
  end

  defp story_module_name(base, fun_name) do
    Module.concat([
      Storybook,
      Components,
      Macro.camelize(base),
      Macro.camelize(to_string(fun_name))
    ])
  end

  defp story_source(story_module, component_module, fun_name) do
    """
    defmodule #{inspect(story_module)} do
      use PhoenixStorybook.Story, :component

      def function, do: &#{inspect(component_module)}.#{fun_name}/1
      def render_source, do: :function

      def variations do
        [
          MySqrftWeb.Storybook.ComponentDefaults.all_params_variation(function(),
            id: :all_params,
            description: "All params"
          )
        ]
      end
    end
    """
  end
end
