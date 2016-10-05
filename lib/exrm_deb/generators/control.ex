defmodule ExrmDeb.Generators.Control do
  @moduledoc ~S"""
  This module builds a control file from the config and a template.
  """
  alias ReleaseManager.Utils.Logger
  alias ExrmDeb.Generators.TemplateFinder
  import Logger, only: [debug: 1]

  def build(config, control_dir) do
    debug "Building Control file"

    out =
      "control.eex"
      |> TemplateFinder.retrieve
      |> EEx.eval_file([
        description: config.description,
        sanitized_name: config.sanitized_name,
        version: config.version,
        licenses: config.licenses,
        vendor: config.vendor,
        arch: config.arch,
        maintainers: config.maintainers,
        installed_size: config.installed_size,
        external_dependencies: config.external_dependencies,
        homepage: config.homepage
      ])

    :ok = File.write(Path.join([control_dir, "control"]), out)
  end

end
