# _plugins/generate_posts_json.rb
require 'json'
require 'fileutils'

module Jekyll
  class PostsJsonGenerator < Generator
    safe true

    def generate(site)
      posts = site.posts.docs.map do |post|
        if post.data['layout']
          {
            title: post.data['title'],
            url: post.url,
            date: post.date,
            categories: post.data['categories'],
            tags: post.data['tags'],
            image: post.data['image']
          }
        end
      end.compact  # `compact`를 사용하여 `nil` 값을 제거

      # `_site` 디렉터리 경로를 동적으로 가져옴
      output_dir = site.dest
      output_file = File.join(output_dir, 'posts.json')

      # 파일을 쓸 디렉터리가 존재하지 않으면 생성
      FileUtils.mkdir_p(File.dirname(output_file))

      # JSON 파일 생성
      File.write(output_file, JSON.pretty_generate(posts))

      # 파일 삭제 방지
      site.keep_files ||= []
      site.keep_files << 'posts.json'
    end
  end
end
