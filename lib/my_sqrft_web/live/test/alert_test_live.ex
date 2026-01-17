defmodule MySqrftWeb.Test.AlertTestLive do
  @moduledoc false
  use MySqrftWeb, :live_view

  import MySqrftWeb.Components.Alert, only: [flash_group: 1, flash: 1, alert: 1]

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="p-8 space-y-8">
        <!-- Basic alert -->
        <.alert>Alert message</.alert>

        <!-- Alert with title -->
        <.alert title="Alert Title">Alert message</.alert>

        <!-- All kinds -->
        <.alert kind={:natural}>Natural</.alert>
        <.alert kind={:primary}>Primary</.alert>
        <.alert kind={:secondary}>Secondary</.alert>
        <.alert kind={:success}>Success</.alert>
        <.alert kind={:warning}>Warning</.alert>
        <.alert kind={:error}>Error</.alert>
        <.alert kind={:danger}>Danger</.alert>
        <.alert kind={:info}>Info</.alert>
        <.alert kind={:misc}>Misc</.alert>
        <.alert kind={:dawn}>Dawn</.alert>
        <.alert kind={:silver}>Silver</.alert>
        <.alert kind={:white}>White</.alert>
        <.alert kind={:dark}>Dark</.alert>

        <!-- All variants -->
        <.alert variant="default">Default</.alert>
        <.alert variant="outline">Outline</.alert>
        <.alert variant="shadow">Shadow</.alert>
        <.alert variant="bordered">Bordered</.alert>
        <.alert variant="gradient">Gradient</.alert>

        <!-- All sizes -->
        <.alert size="extra_small">Extra Small</.alert>
        <.alert size="small">Small</.alert>
        <.alert size="medium">Medium</.alert>
        <.alert size="large">Large</.alert>
        <.alert size="extra_large">Extra Large</.alert>

        <!-- Positions -->
        <.alert position="top_left">Top Left</.alert>
        <.alert position="top_right">Top Right</.alert>
        <.alert position="bottom_left">Bottom Left</.alert>
        <.alert position="bottom_right">Bottom Right</.alert>

        <!-- With icon -->
        <.alert icon="hero-check-circle">With Icon</.alert>
        <.alert icon={nil}>No Icon</.alert>

        <!-- Flash component -->
        <.flash kind={:info} flash={%{info: "Success message"}} />
        <.flash kind={:error} flash={%{error: "Error message"}} />
        <.flash kind={:info}>Custom message</.flash>
        <.flash kind={:info} title="Flash Title">Message</.flash>
        <.flash kind={:info} variant="base">Base variant</.flash>
        <.flash kind={:info} variant="bordered">Bordered variant</.flash>

        <!-- Flash component with all kinds -->
        <.flash kind={:info} flash={%{info: "Info message"}} />
        <.flash kind={:success} flash={%{success: "Success message"}} />
        <.flash kind={:warning} flash={%{warning: "Warning message"}} />
        <.flash kind={:error} flash={%{error: "Error message"}} />
        <.flash kind={:danger} flash={%{danger: "Danger message"}} />
        <.flash kind={:primary} flash={%{primary: "Primary message"}} />
        <.flash kind={:secondary} flash={%{secondary: "Secondary message"}} />
        <.flash kind={:natural} flash={%{natural: "Natural message"}} />
        <.flash kind={:misc} flash={%{misc: "Misc message"}} />
        <.flash kind={:dawn} flash={%{dawn: "Dawn message"}} />
        <.flash kind={:silver} flash={%{silver: "Silver message"}} />
        <.flash kind={:white} flash={%{white: "White message"}} />
        <.flash kind={:dark} flash={%{dark: "Dark message"}} />

        <!-- Flash component with all variants -->
        <.flash kind={:info} variant="default" flash={%{info: "Default"}} />
        <.flash kind={:info} variant="outline" flash={%{info: "Outline"}} />
        <.flash kind={:info} variant="shadow" flash={%{info: "Shadow"}} />
        <.flash kind={:info} variant="bordered" flash={%{info: "Bordered"}} />
        <.flash kind={:info} variant="gradient" flash={%{info: "Gradient"}} />

        <!-- Flash component with all sizes -->
        <.flash kind={:info} size="extra_small" flash={%{info: "XS"}} />
        <.flash kind={:info} size="small" flash={%{info: "Small"}} />
        <.flash kind={:info} size="medium" flash={%{info: "Medium"}} />
        <.flash kind={:info} size="large" flash={%{info: "Large"}} />
        <.flash kind={:info} size="extra_large" flash={%{info: "XL"}} />

        <!-- Flash component with all positions -->
        <.flash kind={:info} position="top_left" flash={%{info: "Top left"}} />
        <.flash kind={:info} position="top_right" flash={%{info: "Top right"}} />
        <.flash kind={:info} position="bottom_left" flash={%{info: "Bottom left"}} />
        <.flash kind={:info} position="bottom_right" flash={%{info: "Bottom right"}} />

        <!-- Flash component with all widths -->
        <.flash kind={:info} width="extra_small" flash={%{info: "XS width"}} />
        <.flash kind={:info} width="small" flash={%{info: "Small width"}} />
        <.flash kind={:info} width="medium" flash={%{info: "Medium width"}} />
        <.flash kind={:info} width="large" flash={%{info: "Large width"}} />
        <.flash kind={:info} width="extra_large" flash={%{info: "XL width"}} />
        <.flash kind={:info} width="fit" flash={%{info: "Fit width"}} />

        <!-- Flash component with icon=nil -->
        <.flash kind={:info} icon={nil} flash={%{info: "No icon"}} />
        <.flash kind={:info} icon="hero-check-circle" flash={%{info: "Custom icon"}} />

        <!-- Flash group -->
        <.flash_group flash={%{info: "Success", error: "Error"}} />
        <.flash_group flash={%{}} position="top_left" />
        <.flash_group flash={%{}} position="top_right" />
        <.flash_group flash={%{}} position="bottom_left" />
        <.flash_group flash={%{}} position="bottom_right" />
        <.flash_group flash={%{}} variant="base" />
        <.flash_group flash={%{}} variant="bordered" />

        <!-- Edge cases: custom binary values -->
        <.alert size="custom-size-value">Custom size</.alert>
        <.alert rounded="custom-rounded-value">Custom rounded</.alert>
        <.alert padding="custom-padding-value">Custom padding</.alert>
        <.alert border="custom-border-value">Custom border</.alert>
        <.alert width="custom-width-value">Custom width</.alert>
        <.alert position="custom-position-value">Custom position</.alert>

        <!-- Edge cases: all rounded sizes -->
        <.alert rounded="full">Full rounded</.alert>
        <.alert rounded="none">No rounded</.alert>

        <!-- Edge cases: all width sizes -->
        <.alert width="extra_small">Extra small width</.alert>
        <.alert width="small">Small width</.alert>
        <.alert width="medium">Medium width</.alert>
        <.alert width="large">Large width</.alert>
        <.alert width="extra_large">Extra large width</.alert>
        <.alert width="fit">Fit width</.alert>

        <!-- Edge cases: all border sizes -->
        <.alert border="none" variant="bordered">No border</.alert>
        <.alert border="extra_small" variant="bordered">Extra small border</.alert>
        <.alert border="small" variant="bordered">Small border</.alert>
        <.alert border="medium" variant="bordered">Medium border</.alert>
        <.alert border="large" variant="bordered">Large border</.alert>
        <.alert border="extra_large" variant="bordered">Extra large border</.alert>

        <!-- Edge cases: all color variants for different variants -->
        <.alert kind={:white} variant="default">White default</.alert>
        <.alert kind={:dark} variant="default">Dark default</.alert>
        <.alert kind={:white} variant="shadow">White shadow</.alert>
        <.alert kind={:dark} variant="shadow">Dark shadow</.alert>
        <.alert kind={:white} variant="bordered">White bordered</.alert>
        <.alert kind={:dark} variant="bordered">Dark bordered</.alert>
        <.alert kind={:white} variant="gradient">White gradient</.alert>
        <.alert kind={:dark} variant="gradient">Dark gradient</.alert>

        <!-- Edge cases: all kinds with different variants -->
        <.alert kind={:error} variant="outline">Error outline</.alert>
        <.alert kind={:error} variant="shadow">Error shadow</.alert>
        <.alert kind={:error} variant="bordered">Error bordered</.alert>
        <.alert kind={:error} variant="gradient">Error gradient</.alert>

        <!-- Edge cases: all outline variants for all colors -->
        <.alert kind={:natural} variant="outline">Natural outline</.alert>
        <.alert kind={:primary} variant="outline">Primary outline</.alert>
        <.alert kind={:secondary} variant="outline">Secondary outline</.alert>
        <.alert kind={:success} variant="outline">Success outline</.alert>
        <.alert kind={:warning} variant="outline">Warning outline</.alert>
        <.alert kind={:danger} variant="outline">Danger outline</.alert>
        <.alert kind={:info} variant="outline">Info outline</.alert>
        <.alert kind={:misc} variant="outline">Misc outline</.alert>
        <.alert kind={:dawn} variant="outline">Dawn outline</.alert>
        <.alert kind={:silver} variant="outline">Silver outline</.alert>

        <!-- Edge cases: all shadow variants for all colors -->
        <.alert kind={:natural} variant="shadow">Natural shadow</.alert>
        <.alert kind={:primary} variant="shadow">Primary shadow</.alert>
        <.alert kind={:secondary} variant="shadow">Secondary shadow</.alert>
        <.alert kind={:success} variant="shadow">Success shadow</.alert>
        <.alert kind={:warning} variant="shadow">Warning shadow</.alert>
        <.alert kind={:danger} variant="shadow">Danger shadow</.alert>
        <.alert kind={:info} variant="shadow">Info shadow</.alert>
        <.alert kind={:misc} variant="shadow">Misc shadow</.alert>
        <.alert kind={:dawn} variant="shadow">Dawn shadow</.alert>
        <.alert kind={:silver} variant="shadow">Silver shadow</.alert>

        <!-- Edge cases: all bordered variants for all colors -->
        <.alert kind={:natural} variant="bordered">Natural bordered</.alert>
        <.alert kind={:primary} variant="bordered">Primary bordered</.alert>
        <.alert kind={:secondary} variant="bordered">Secondary bordered</.alert>
        <.alert kind={:success} variant="bordered">Success bordered</.alert>
        <.alert kind={:warning} variant="bordered">Warning bordered</.alert>
        <.alert kind={:danger} variant="bordered">Danger bordered</.alert>
        <.alert kind={:info} variant="bordered">Info bordered</.alert>
        <.alert kind={:misc} variant="bordered">Misc bordered</.alert>
        <.alert kind={:dawn} variant="bordered">Dawn bordered</.alert>
        <.alert kind={:silver} variant="bordered">Silver bordered</.alert>

        <!-- Edge cases: all gradient variants for all colors -->
        <.alert kind={:natural} variant="gradient">Natural gradient</.alert>
        <.alert kind={:primary} variant="gradient">Primary gradient</.alert>
        <.alert kind={:secondary} variant="gradient">Secondary gradient</.alert>
        <.alert kind={:success} variant="gradient">Success gradient</.alert>
        <.alert kind={:warning} variant="gradient">Warning gradient</.alert>
        <.alert kind={:danger} variant="gradient">Danger gradient</.alert>
        <.alert kind={:info} variant="gradient">Info gradient</.alert>
        <.alert kind={:misc} variant="gradient">Misc gradient</.alert>
        <.alert kind={:dawn} variant="gradient">Dawn gradient</.alert>
        <.alert kind={:silver} variant="gradient">Silver gradient</.alert>
      </div>
    </Layouts.app>
    """
  end
end
