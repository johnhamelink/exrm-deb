defmodule ExrmDeb.Utils.File do
  alias  ReleaseManager.Utils.Logger
  import Logger, only: [debug: 1]

  @doc """
  Retrieves all the files within a directory, retrieves the size of all these
  files, then adds them all together.
  """
  def get_dir_size(dir) do
    {_parts, size} =
      [dir, "**"]
      |> Path.join
      |> Path.wildcard
      |> Enum.map_reduce(0, fn(file, acc) ->
        size = File.stat!(file).size
        {size, size + acc}
      end)
    size
  end

  @doc """
  Remove junk files from the data directory.
  """
  def remove_fs_metadata(data_dir) do
    debug "Removing Filesystem metadata"
    [data_dir, Path.join([data_dir, "**"])]
    |> Enum.each(fn(path) ->
      path
        |> ExrmDeb.Utils.File.remove_all_files_by_name(".DS_Store")
        |> ExrmDeb.Utils.File.remove_all_files_by_name("thumbs.db")
    end)
  end

  @doc """
  Remove all files that match a name
  """
  def remove_all_files_by_name(root, name) do
    [root, name]
    |> Path.join
    |> Path.wildcard
    |> Enum.each(&(File.rm(&1)))

    root
  end

  @doc """
  Remove tmp directories used when building the deb
  """
  def remove_tmp(dir) do
    debug "Removing #{dir}"
    {:ok, _files} = File.rm_rf(dir)
  end

end
