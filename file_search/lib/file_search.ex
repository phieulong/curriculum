defmodule FileSearch do
  @moduledoc """
  Documentation for FileSearch
  """

  @doc """
  Find all nested files.

  For example, given the following folder structure
  /main
    /sub1
      file1.txt
    /sub2
      file2.txt
    /sub3
      file3.txt
    file4.txt

  It would return:

  ["file1.txt", "file2.txt", "file3.txt", "file4.txt"]
  iex> File.mkdir_p!("main/sub1")
  iex> File.write!("main/sub1/file1.txt", "")
  iex> File.mkdir_p!("main/sub2")
  iex> File.write!("main/sub2/file2.txt", "")
  iex> File.mkdir_p!("main/sub3")
  iex> File.write!("main/sub3/file3.txt", "")
  :ok
  iex> File.write!("main/file4.txt", "")
  :ok
  iex> FileSearch.all("main")
  [
       "file4.txt",
       "file1.png",
       "file1.txt",
       "file2.png",
       "file2.txt",
       "file3.jpg",
       "file3.txt"
  ]
  """
  def all(folder) do
    Path.wildcard(Path.join([folder, "**", "*.*"]))
    |> Enum.map(&Path.basename/1)
  end

  @doc """
  Find all nested files and categorize them by their extension.

  For example, given the following folder structure
  /main
    /sub1
      file1.txt
      file1.png
    /sub2
      file2.txt
      file2.png
    /sub3
      file3.txt
      file3.jpg
    file4.txt

  The exact order and return value are up to you as long as it finds all files
  and categorizes them by file extension.

  For example, it might return the following:

  %{
    ".txt" => ["file1.txt", "file2.txt", "file3.txt", "file4.txt"],
    ".png" => ["file1.png", "file2.png"],
    ".jpg" => ["file3.jpg"]
  }

  iex> File.write!("main/sub1/file1.png", "")
  :ok
  iex> File.write!("main/sub2/file2.png", "")
  :ok
  iex> File.write!("main/sub3/file3.jpg", "")
  :ok
  iex> FileSearch.by_extension("main")
  %{
    "jpg" => ["file3.jpg"],
    "png" => ["file1.png", "file2.png"],
    "txt" => ["file4.txt", "file1.txt", "file2.txt", "file3.txt"]
  }
  """
  def by_extension(folder) do
    folder
    |> all()
    |> Enum.group_by(fn e -> List.last(String.split(e, ".")) end)
  end

  def main(args) do
    {opts, _word, _errors} = OptionParser.parse(args, switches: [type: :boolean])

    case opts[:type] || false do
      true -> FileSearch.by_extension(".") |> IO.inspect()
      false -> FileSearch.all(".") |> IO.inspect()
    end
  end
end
