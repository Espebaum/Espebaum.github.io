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

      # 루트 디렉토리 경로를 동적으로 가져옴
      root_output_file = File.join(site.source, 'posts.json')
      site_output_file = File.join(site.dest, 'posts.json')

      # 루트 디렉토리에 JSON 파일 생성
      File.write(root_output_file, JSON.pretty_generate(posts))

      # _site 디렉토리에 JSON 파일 생성
      File.write(site_output_file, JSON.pretty_generate(posts))

      # 파일 삭제 방지
      site.keep_files ||= []
      site.keep_files << 'posts.json'
    end
  end
end
