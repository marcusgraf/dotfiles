class Dotfile
  FILENAME_ALIGN_WIDTH = 25

  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def link
    if symlinked?
      info("already symlinked")
    elsif exists?
      info("EXISTS")
    else
      create_symlink
      info("symlinked")
    end
  end

  def unlink
    if symlinked?
      remove_symlink
      info("symlink removed")
    else
      info("ignored")
    end
  end

  def to_s
    "~/#{dotfilename}"
  end

  private

  def dotfilename
    ".#{filename}"
  end

  def info(message)
    puts "#{to_s.ljust(FILENAME_ALIGN_WIDTH)} #{message}"
  end

  def exists?
    File.exists?(destination_path)
  end

  def symlinked?
    File.symlink?(destination_path) && File.readlink(destination_path) == source_path
  end

  def create_symlink
    FileUtils.ln_s(source_path, destination_path)
  end

  def remove_symlink
    FileUtils.rm(destination_path)
  end

  def destination_path
    File.join(ENV["HOME"], dotfilename)
  end

  def source_path
    File.expand_path("./#{filename}")
  end
end