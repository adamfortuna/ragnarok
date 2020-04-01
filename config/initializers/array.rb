class Array
  def sum
    inject(0.0) { |result, el| result + el }
  end

  def mean
    sum / size
  end

  def avg
    (sum*1.0 / length*1.0).to_f
  end
end
