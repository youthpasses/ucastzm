#coding: utf-8
module ApplicationHelper
  
  # 根据所在页面返回完整地标题
  def full_title(page_title = '')
  	base_title = "国科大跳蚤市场"
  	if page_title.empty?
  		base_title
  	else
  		page_title + ' | ' + base_title
  	end
  end
end
