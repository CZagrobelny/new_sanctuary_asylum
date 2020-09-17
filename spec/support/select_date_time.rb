module SelectDateTime
  def select_date_and_time(date, options = {})
    field = options[:from]
    select date.strftime('%Y'), :from => "#{field}_1i" #year
    select date.strftime('%B'), :from => "#{field}_2i" #month
    select date.strftime('%-d'), :from => "#{field}_3i" #day
    select date.strftime('%I %p'), :from => "#{field}_4i" #hour
    select date.strftime('%M'), :from => "#{field}_5i" #minute
  end
end
