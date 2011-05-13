require 'rubygems'
require 'fileutils'
require 'plist'

LIST = ARGV[0] || "Android"
ITUNES_DIR = File.expand_path("~/Music/iTunes")
DEST_DIR = "/Volumes/droid/media/audio/itunes"

library_file = File.join ITUNES_DIR, "iTunes Music Library.xml"
basedir = File.join ITUNES_DIR, "iTunes Music"

puts "Parsing iTunes Library"
r = Plist::parse_xml(library_file)

puts "Finding playlist #{LIST}"
playlist = r["Playlists"].find do |pl|
  pl["Name"] == LIST
end

all_tracks = r["Tracks"]
tracks = playlist["Playlist Items"].map do |item|
  id = item["Track ID"].to_s
  CGI::unescape(all_tracks[id]["Location"].sub("file://localhost", ""))
end


puts "Syncing to #{DEST_DIR}"
tracks.each_with_index do |src, i|
  part = src.sub(basedir, '')

  dest = DEST_DIR + part

  puts "#{i + 1} / #{tracks.size}"

  unless File.exists?(dest)
    FileUtils.mkdir_p(File.dirname(dest))
    FileUtils.cp(src, dest)
  end
end


