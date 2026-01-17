defmodule MySqrftWeb.Test.NavbarTestLive do
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
      <div class="space-y-8">
        <!-- Basic navbar -->
        <.navbar id="navbar-basic">
          <:list>
            <.link navigate="/">Home</.link>
          </:list>
        </.navbar>

        <!-- Navbar with name and link -->
        <.navbar id="navbar-name" name="My App" link="/">
          <:list>
            <.link navigate="/">Home</.link>
          </:list>
        </.navbar>

        <!-- Navbar with image -->
        <.navbar id="navbar-image" image="/logo.png" link="/">
          <:list>
            <.link navigate="/">Home</.link>
          </:list>
        </.navbar>

        <!-- All color variants -->
        <.navbar id="navbar-natural" color="natural">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-primary" color="primary">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-secondary" color="secondary">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-success" color="success">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-warning" color="warning">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-danger" color="danger">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-info" color="info">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-misc" color="misc">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-dawn" color="dawn">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-silver" color="silver">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-white" color="white">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-dark" color="dark">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>

        <!-- All variant styles -->
        <.navbar id="navbar-base" variant="base">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-shadow" variant="shadow">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-bordered" variant="bordered">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-gradient" variant="gradient">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>

        <!-- Content positions -->
        <.navbar id="navbar-start" content_position="start">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-end" content_position="end">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-center" content_position="center">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-between" content_position="between">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-around" content_position="around">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>

        <!-- Padding sizes -->
        <.navbar id="navbar-padding-xs" padding="extra_small">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-padding-sm" padding="small">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-padding-md" padding="medium">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-padding-lg" padding="large">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-padding-xl" padding="extra_large">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-padding-none" padding="none">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>

        <!-- Border sizes -->
        <.navbar id="navbar-border-xs" border="extra_small">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-border-sm" border="small">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-border-md" border="medium">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-border-lg" border="large">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-border-xl" border="extra_large">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-border-none" border="none">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>

        <!-- Rounded styles -->
        <.navbar id="navbar-rounded-xs" rounded="extra_small">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-rounded-sm" rounded="small">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-rounded-md" rounded="medium">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-rounded-lg" rounded="large">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-rounded-xl" rounded="extra_large">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>

        <!-- Max width -->
        <.navbar id="navbar-maxw-xs" max_width="extra_small">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-maxw-sm" max_width="small">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-maxw-md" max_width="medium">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-maxw-lg" max_width="large">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-maxw-xl" max_width="extra_large">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>

        <!-- Start and end content -->
        <.navbar id="navbar-start-content">
          <:start_content>Start</:start_content>
          <:end_content>End</:end_content>
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>

        <!-- Multiple list items -->
        <.navbar id="navbar-multiple">
          <:list><.link navigate="/">Home</.link></:list>
          <:list><.link navigate="/about">About</.link></:list>
          <:list><.link navigate="/contact">Contact</.link></:list>
        </.navbar>

        <!-- Header component -->
        <.header>Test Title</.header>
        <.header>
          Test Title
          <:subtitle>Subtitle text</:subtitle>
        </.header>
        <.header>
          Test Title
          <:actions>
            <button>Action</button>
          </:actions>
        </.header>

        <!-- Edge cases: all text positions -->
        <.navbar id="navbar-text-left" text_position="left">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-text-right" text_position="right">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-text-center" text_position="center">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-text-custom" text_position="custom-text">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>

        <!-- Edge cases: all space classes -->
        <.navbar id="navbar-space-xs" space="extra_small">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-space-sm" space="small">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-space-md" space="medium">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-space-lg" space="large">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-space-xl" space="extra_large">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-space-custom" space="custom-space">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>

        <!-- Edge cases: all rounded sizes -->
        <.navbar id="navbar-rounded-none" rounded="none">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-rounded-full" rounded="full">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-rounded-custom" rounded="custom-rounded">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>

        <!-- Edge cases: custom binary values -->
        <.navbar id="navbar-custom-padding" padding="custom-padding">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-custom-border" border="custom-border">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-custom-rounded" rounded="custom-rounded">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-custom-maxw" max_width="custom-maxw">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-custom-space" space="custom-space">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-custom-content" content_position="custom-content">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-custom-text" text_position="custom-text">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>

        <!-- Edge cases: all shadow variants for all colors -->
        <.navbar id="navbar-shadow-natural" variant="shadow" color="natural">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-shadow-primary" variant="shadow" color="primary">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-shadow-secondary" variant="shadow" color="secondary">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-shadow-success" variant="shadow" color="success">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-shadow-warning" variant="shadow" color="warning">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-shadow-danger" variant="shadow" color="danger">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-shadow-info" variant="shadow" color="info">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-shadow-misc" variant="shadow" color="misc">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-shadow-dawn" variant="shadow" color="dawn">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-shadow-silver" variant="shadow" color="silver">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-shadow-white" variant="shadow" color="white">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-shadow-dark" variant="shadow" color="dark">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>

        <!-- Edge cases: all bordered variants for all colors -->
        <.navbar id="navbar-bordered-natural" variant="bordered" color="natural">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-bordered-primary" variant="bordered" color="primary">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-bordered-secondary" variant="bordered" color="secondary">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-bordered-success" variant="bordered" color="success">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-bordered-warning" variant="bordered" color="warning">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-bordered-danger" variant="bordered" color="danger">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-bordered-info" variant="bordered" color="info">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-bordered-misc" variant="bordered" color="misc">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-bordered-dawn" variant="bordered" color="dawn">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-bordered-silver" variant="bordered" color="silver">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-bordered-white" variant="bordered" color="white">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-bordered-dark" variant="bordered" color="dark">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>

        <!-- Edge cases: all gradient variants for all colors -->
        <.navbar id="navbar-gradient-natural" variant="gradient" color="natural">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-gradient-primary" variant="gradient" color="primary">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-gradient-secondary" variant="gradient" color="secondary">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-gradient-success" variant="gradient" color="success">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-gradient-warning" variant="gradient" color="warning">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-gradient-danger" variant="gradient" color="danger">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-gradient-info" variant="gradient" color="info">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-gradient-misc" variant="gradient" color="misc">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-gradient-dawn" variant="gradient" color="dawn">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-gradient-silver" variant="gradient" color="silver">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>

        <!-- Edge cases: bordered variant with white and dark colors -->
        <.navbar id="navbar-bordered-white" variant="bordered" color="white">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-bordered-dark" variant="bordered" color="dark">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>

        <!-- Edge cases: gradient variant with white and dark colors -->
        <.navbar id="navbar-gradient-white" variant="gradient" color="white">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-gradient-dark" variant="gradient" color="dark">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>

        <!-- Edge cases: all border sizes for bordered variant -->
        <.navbar id="navbar-border-none" variant="bordered" border="none">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-border-xs-bordered" variant="bordered" border="extra_small">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-border-sm-bordered" variant="bordered" border="small">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-border-md-bordered" variant="bordered" border="medium">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-border-lg-bordered" variant="bordered" border="large">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
        <.navbar id="navbar-border-xl-bordered" variant="bordered" border="extra_large">
          <:list><.link navigate="/">Home</.link></:list>
        </.navbar>
      </div>
    </Layouts.app>
    """
  end
end
