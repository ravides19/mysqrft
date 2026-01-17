defmodule MySqrftWeb.Test.ModalTestLive do
  @moduledoc false
  use MySqrftWeb, :live_view

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
        <!-- Basic modal -->
        <.modal id="modal-basic">
          <p>Basic modal content</p>
        </.modal>

        <!-- Modal with title -->
        <.modal id="modal-title" title="Test Title">
          <p>Modal with title</p>
        </.modal>

        <!-- Modal with show -->
        <.modal id="modal-show" show>
          <p>Shown modal</p>
        </.modal>

        <!-- Modal without title -->
        <.modal id="modal-no-title">
          <p>Modal without title</p>
        </.modal>

        <!-- Modal with on_cancel -->
        <.modal id="modal-on-cancel" on_cancel={%Phoenix.LiveView.JS{}}>
          <p>Modal with on_cancel</p>
        </.modal>

        <!-- Modal with all custom classes -->
        <.modal
          id="modal-all-classes"
          class="custom-class"
          title_class="custom-title"
          icon_class="custom-icon"
          content_class="custom-content"
          close_class="custom-close"
          focus_wrap_class="custom-focus"
          inner_wrapper_class="custom-inner"
          wrapper_class="custom-wrapper"
          overlay_class="custom-overlay"
        >
          <p>Modal with all custom classes</p>
        </.modal>

        <!-- All color variants -->
        <.modal id="modal-natural" color="natural">
          <p>Natural color</p>
        </.modal>
        <.modal id="modal-primary" color="primary">
          <p>Primary color</p>
        </.modal>
        <.modal id="modal-secondary" color="secondary">
          <p>Secondary color</p>
        </.modal>
        <.modal id="modal-success" color="success">
          <p>Success color</p>
        </.modal>
        <.modal id="modal-warning" color="warning">
          <p>Warning color</p>
        </.modal>
        <.modal id="modal-danger" color="danger">
          <p>Danger color</p>
        </.modal>
        <.modal id="modal-info" color="info">
          <p>Info color</p>
        </.modal>
        <.modal id="modal-misc" color="misc">
          <p>Misc color</p>
        </.modal>
        <.modal id="modal-dawn" color="dawn">
          <p>Dawn color</p>
        </.modal>
        <.modal id="modal-silver" color="silver">
          <p>Silver color</p>
        </.modal>
        <.modal id="modal-white" color="white">
          <p>White color</p>
        </.modal>
        <.modal id="modal-dark" color="dark">
          <p>Dark color</p>
        </.modal>

        <!-- All variant styles -->
        <.modal id="modal-base" variant="base">
          <p>Base variant</p>
        </.modal>
        <.modal id="modal-shadow" variant="shadow">
          <p>Shadow variant</p>
        </.modal>
        <.modal id="modal-bordered" variant="bordered">
          <p>Bordered variant</p>
        </.modal>
        <.modal id="modal-gradient" variant="gradient">
          <p>Gradient variant</p>
        </.modal>

        <!-- All sizes -->
        <.modal id="modal-xs" size="extra_small">
          <p>Extra small</p>
        </.modal>
        <.modal id="modal-sm" size="small">
          <p>Small</p>
        </.modal>
        <.modal id="modal-md" size="medium">
          <p>Medium</p>
        </.modal>
        <.modal id="modal-lg" size="large">
          <p>Large</p>
        </.modal>
        <.modal id="modal-xl" size="extra_large">
          <p>Extra large</p>
        </.modal>

        <!-- All rounded styles -->
        <.modal id="modal-rounded-xs" rounded="extra_small">
          <p>Extra small rounded</p>
        </.modal>
        <.modal id="modal-rounded-sm" rounded="small">
          <p>Small rounded</p>
        </.modal>
        <.modal id="modal-rounded-md" rounded="medium">
          <p>Medium rounded</p>
        </.modal>
        <.modal id="modal-rounded-lg" rounded="large">
          <p>Large rounded</p>
        </.modal>
        <.modal id="modal-rounded-xl" rounded="extra_large">
          <p>Extra large rounded</p>
        </.modal>
        <.modal id="modal-rounded-none" rounded="none">
          <p>No rounded</p>
        </.modal>

        <!-- All padding sizes -->
        <.modal id="modal-padding-xs" padding="extra_small">
          <p>Extra small padding</p>
        </.modal>
        <.modal id="modal-padding-sm" padding="small">
          <p>Small padding</p>
        </.modal>
        <.modal id="modal-padding-md" padding="medium">
          <p>Medium padding</p>
        </.modal>
        <.modal id="modal-padding-lg" padding="large">
          <p>Large padding</p>
        </.modal>
        <.modal id="modal-padding-xl" padding="extra_large">
          <p>Extra large padding</p>
        </.modal>
        <.modal id="modal-padding-none" padding="none">
          <p>No padding</p>
        </.modal>

        <!-- Border sizes -->
        <.modal id="modal-border-xs" border="extra_small">
          <p>Extra small border</p>
        </.modal>
        <.modal id="modal-border-sm" border="small">
          <p>Small border</p>
        </.modal>
        <.modal id="modal-border-md" border="medium">
          <p>Medium border</p>
        </.modal>
        <.modal id="modal-border-lg" border="large">
          <p>Large border</p>
        </.modal>
        <.modal id="modal-border-xl" border="extra_large">
          <p>Extra large border</p>
        </.modal>
        <.modal id="modal-border-none" border="none">
          <p>No border</p>
        </.modal>

        <!-- Border with variants that return nil (default, shadow, gradient) -->
        <.modal id="modal-default-border-xs" variant="default" border="extra_small">
          <p>Default variant with border</p>
        </.modal>
        <.modal id="modal-shadow-border-xs" variant="shadow" border="extra_small">
          <p>Shadow variant with border</p>
        </.modal>
        <.modal id="modal-gradient-border-xs" variant="gradient" border="extra_small">
          <p>Gradient variant with border</p>
        </.modal>
        <.modal id="modal-default-border-none" variant="default" border="none">
          <p>Default variant with no border</p>
        </.modal>
        <.modal id="modal-shadow-border-none" variant="shadow" border="none">
          <p>Shadow variant with no border</p>
        </.modal>
        <.modal id="modal-gradient-border-none" variant="gradient" border="none">
          <p>Gradient variant with no border</p>
        </.modal>

        <!-- Custom classes -->
        <.modal id="modal-custom" class="custom-class" title_class="custom-title">
          <p>Custom classes</p>
        </.modal>

        <!-- Edge cases: custom binary values for sizes -->
        <.modal id="modal-custom-size" size="custom-size-value">
          <p>Custom size</p>
        </.modal>
        <.modal id="modal-custom-rounded" rounded="custom-rounded-value">
          <p>Custom rounded</p>
        </.modal>
        <.modal id="modal-custom-padding" padding="custom-padding-value">
          <p>Custom padding</p>
        </.modal>
        <.modal id="modal-custom-border" border="custom-border-value">
          <p>Custom border</p>
        </.modal>

        <!-- Edge cases: all variant/color combinations for shadow -->
        <.modal id="modal-shadow-natural" variant="shadow" color="natural">
          <p>Shadow natural</p>
        </.modal>
        <.modal id="modal-shadow-primary" variant="shadow" color="primary">
          <p>Shadow primary</p>
        </.modal>
        <.modal id="modal-shadow-secondary" variant="shadow" color="secondary">
          <p>Shadow secondary</p>
        </.modal>
        <.modal id="modal-shadow-success" variant="shadow" color="success">
          <p>Shadow success</p>
        </.modal>
        <.modal id="modal-shadow-warning" variant="shadow" color="warning">
          <p>Shadow warning</p>
        </.modal>
        <.modal id="modal-shadow-danger" variant="shadow" color="danger">
          <p>Shadow danger</p>
        </.modal>
        <.modal id="modal-shadow-info" variant="shadow" color="info">
          <p>Shadow info</p>
        </.modal>
        <.modal id="modal-shadow-misc" variant="shadow" color="misc">
          <p>Shadow misc</p>
        </.modal>
        <.modal id="modal-shadow-dawn" variant="shadow" color="dawn">
          <p>Shadow dawn</p>
        </.modal>
        <.modal id="modal-shadow-silver" variant="shadow" color="silver">
          <p>Shadow silver</p>
        </.modal>
        <.modal id="modal-shadow-white" variant="shadow" color="white">
          <p>Shadow white</p>
        </.modal>
        <.modal id="modal-shadow-dark" variant="shadow" color="dark">
          <p>Shadow dark</p>
        </.modal>

        <!-- Edge cases: all variant/color combinations for bordered -->
        <.modal id="modal-bordered-natural" variant="bordered" color="natural">
          <p>Bordered natural</p>
        </.modal>
        <.modal id="modal-bordered-primary" variant="bordered" color="primary">
          <p>Bordered primary</p>
        </.modal>
        <.modal id="modal-bordered-secondary" variant="bordered" color="secondary">
          <p>Bordered secondary</p>
        </.modal>
        <.modal id="modal-bordered-success" variant="bordered" color="success">
          <p>Bordered success</p>
        </.modal>
        <.modal id="modal-bordered-warning" variant="bordered" color="warning">
          <p>Bordered warning</p>
        </.modal>
        <.modal id="modal-bordered-danger" variant="bordered" color="danger">
          <p>Bordered danger</p>
        </.modal>
        <.modal id="modal-bordered-info" variant="bordered" color="info">
          <p>Bordered info</p>
        </.modal>
        <.modal id="modal-bordered-misc" variant="bordered" color="misc">
          <p>Bordered misc</p>
        </.modal>
        <.modal id="modal-bordered-dawn" variant="bordered" color="dawn">
          <p>Bordered dawn</p>
        </.modal>
        <.modal id="modal-bordered-silver" variant="bordered" color="silver">
          <p>Bordered silver</p>
        </.modal>
        <.modal id="modal-bordered-white" variant="bordered" color="white">
          <p>Bordered white</p>
        </.modal>
        <.modal id="modal-bordered-dark" variant="bordered" color="dark">
          <p>Bordered dark</p>
        </.modal>

        <!-- Edge cases: all variant/color combinations for gradient -->
        <.modal id="modal-gradient-natural" variant="gradient" color="natural">
          <p>Gradient natural</p>
        </.modal>
        <.modal id="modal-gradient-primary" variant="gradient" color="primary">
          <p>Gradient primary</p>
        </.modal>
        <.modal id="modal-gradient-secondary" variant="gradient" color="secondary">
          <p>Gradient secondary</p>
        </.modal>
        <.modal id="modal-gradient-success" variant="gradient" color="success">
          <p>Gradient success</p>
        </.modal>
        <.modal id="modal-gradient-warning" variant="gradient" color="warning">
          <p>Gradient warning</p>
        </.modal>
        <.modal id="modal-gradient-danger" variant="gradient" color="danger">
          <p>Gradient danger</p>
        </.modal>
        <.modal id="modal-gradient-info" variant="gradient" color="info">
          <p>Gradient info</p>
        </.modal>
        <.modal id="modal-gradient-misc" variant="gradient" color="misc">
          <p>Gradient misc</p>
        </.modal>
        <.modal id="modal-gradient-dawn" variant="gradient" color="dawn">
          <p>Gradient dawn</p>
        </.modal>
        <.modal id="modal-gradient-silver" variant="gradient" color="silver">
          <p>Gradient silver</p>
        </.modal>
        <.modal id="modal-gradient-white" variant="gradient" color="white">
          <p>Gradient white</p>
        </.modal>
        <.modal id="modal-gradient-dark" variant="gradient" color="dark">
          <p>Gradient dark</p>
        </.modal>

        <!-- Edge cases: bordered variant with white and dark colors -->
        <.modal id="modal-bordered-white" variant="bordered" color="white">
          <p>Bordered white</p>
        </.modal>
        <.modal id="modal-bordered-dark" variant="bordered" color="dark">
          <p>Bordered dark</p>
        </.modal>

        <!-- Edge cases: gradient variant with white and dark colors -->
        <.modal id="modal-gradient-white" variant="gradient" color="white">
          <p>Gradient white</p>
        </.modal>
        <.modal id="modal-gradient-dark" variant="gradient" color="dark">
          <p>Gradient dark</p>
        </.modal>
      </div>
    </Layouts.app>
    """
  end
end
