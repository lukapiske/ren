module Output::AxsToNewcarsHelper


  def timestamp_for(how)
    interval = Date.today.to_time - how.month.to_i
    return interval.to_i
  end

  


end
