#    Log Mysteries: partial answer for Honeynet challenge
#    Reference: http://honeynet.org/challenges/2010_5_log_mysteries
#    Copyright (C) 2010  Dr. Carl J. Pulley
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

# TODO: ensure we also record file hashes in our database tables!!
# TODO: want some hashes present so that we can match against partial files (eg. 4kB block hashing)

# TODO: we can not use Ruby Subversion bindings with Ruby 1.9 (they do not yet build!), so we're forced to use approx. the following XML type hacks
def build_artefact(repos_url, entry)
  Nokogiri::XML(`svn list -R --xml --incremental #{repos_url}`).xpath("//entry").each do |artefact|
    if artefact[:kind] == 'file'
      item = FileArtefact.find_or_create_by_path(:path => artefact.at_css("name").content, :size => artefact.at_css("size").content.to_i, :submitted_at => artefact.at_css("date").content, :revision => artefact.at_css("commit")[:revision])
    else
      item = DirArtefact.find_or_create_by_path(:path => artefact.at_css("name").content, :size => 0, :submitted_at => artefact.at_css("date").content, :revision => artefact.at_css("commit")[:revision])
    end
    entry.artefacts << item unless entry.artefacts.member? item
  end
end

def build_entries(repos_url, repository)
  `svn list #{repos_url}`.split.each do |base|
    if base =~ /trunk\/?$/
      entry = Entry.find_or_create_by_name(:name => "trunk", :repository => repository)
      repository.trunk = entry if entry.new_record?
      build_artefact("#{repos_url}/trunk", entry)
    elsif base =~ /branches\/?$/
      `svn list #{repos_url}/branches`.split.each do |branch|
        entry = BranchEntry.find_or_create_by_name(:name => "branches/#{branch}", :repository => repository)
        repository.branches << entry if entry.new_record?
        build_artefact("#{repos_url}/branches/#{branch}", entry)
      end
    elsif base =~ /tags\/?$/
      `svn list #{repos_url}/tags`.split.each do |tag|
        entry = TagEntry.find_or_create_by_name(:name => "tags/#{tag}", :repository => repository)
        repository.tags << entry if entry.new_record?
        build_artefact("#{repos_url}/tags/#{tag}", entry)
      end
    end
  end
end

namespace :checkout do
  namespace :svn do    
    desc "Checkout the Wordpress subversion source code repository. \nNOTE: This rake task can safely be called multiple times (eg. you're updating to subversion HEAD)."
    task :wordpress => :environment do
      repos = "core.svn.wordpress.org"
      puts "Checking out #{repos}..."
      puts `svn update http://#{repos} evidence/wordpress` if File.exists? "evidence/wordpress"
      puts `svn co http://#{repos} evidence/wordpress` unless File.exists? "evidence/wordpress"
    end
    
    desc "Checkout the Wordpress plugin subversion source code repositories. \nNOTE: This rake task can safely be called multiple times (eg. you're updating to subversion HEAD)."
    task :wp_plugins => :environment do
      repos = "svn.wp-plugins.org"
      puts "Checking out #{repos}..."
      `svn list evidence/wp-plugins`.split.each do |item|
        puts `svn update http://#{repos}/#{item} evidence/wp-plugins/#{item}` if File.exists? "evidence/wp-plugins/#{item}"
        puts `svn co http://#{repos}/#{item} evidence/wp-plugins/#{item}` unless File.exists? "evidence/wp-plugins/#{item}"
      end
    end
  end
end

namespace :build do
  namespace :svn do    
    desc "Builds DB tables for the Wordpress subversion source code repository. \nNOTE: This rake task can safely be called multiple times (eg. you're updating to subversion HEAD)."
    task :wordpress => :environment do
      repos = "core.svn.wordpress.org"
      puts "Building #{repos} database tables..."
      repository = Repository.find_or_create_by_url(:url => "evidence", :name => "wordpress")
      build_entries("evidence/wordpress", repository)
      repository.save!
    end
    
    desc "Builds DB tables for all the Wordpress plugin subversion source code repositories. \nNOTE: This rake task can safely be called multiple times (eg. you're updating to subversion HEAD)."
    task :wp_plugins => :environment do
      repos = "svn.wp-plugins.org"
      puts "Building #{repos} database tables..."
      `svn list evidence/wp-plugins`.split.each do |item|
        repository = Repository.find_or_create_by_url(:url => "evidence/wp-plugins/#{item}", :name => "wp-plugins/#{item}")
        build_entries("evidence/wp-plugins/#{item}", repository)
        repository.save!
      end
    end
  end
end