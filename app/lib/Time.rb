class Time  
  def week_number
    self.strftime('%U').to_i
  end
  
  def dag_naam
    dn=["zondag", "maandag", "dinsdag", "woensdag", "donderdag", "vrijdag"][self.wday]
    now_week = Time.now.week_number
    if week_number == now_week +1
      dn="Volgende week " +dn
    elsif week_number > now_week
      dn="Over #{week_number-now_week} #{dn}"
    end
    dn
  end
  
end