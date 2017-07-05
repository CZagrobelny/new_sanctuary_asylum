module SelectFromChosen
  def select_from_chosen(item_text, options)
    debugger
    field_id = find_field(options[:from])[:id]
    within "##{field_id}" do
      find('a.chzn-single').click
      input = find("div.chzn-search input").native
      input.send_keys(item_text)
      find('ul.chzn-results').click
      input.send_key(:arrow_down, :return)
      within 'a.chzn-single' do
        page.should have_content item_text
      end
    end
  end
end