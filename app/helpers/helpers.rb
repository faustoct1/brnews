Linked4::App.helpers do
  def _topicn item
    topicn=nil
    if item['topic_id']==2
      topicn='Política'
    elsif item['topic_id']==3
      topicn='Economia'
    elsif item['topic_id']==4
      topicn='Esporte'
    elsif item['topic_id']==5
      topicn='Tecnologia'
    elsif item['topic_id']==6
      topicn='Negócios'
    end
    topicn
  end
  def _bgcolortpc item
    color='#fff'
    if item['topic_id']==2
      color='#F5A701'
    elsif item['topic_id']==3
      color='#800080'
    elsif item['topic_id']==4
      color='#008000'
    elsif item['topic_id']==5
      color='#3B5998'
    elsif item['topic_id']==6
      color='#E62117'
    end
  end
end
