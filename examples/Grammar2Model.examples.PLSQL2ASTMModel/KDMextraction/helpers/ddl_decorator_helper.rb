
SQLTypes = Hash.new

decorator Astm::Sastm::RDBColumnDefinition do
  def resolveType
    if (self.get('type') && self.get('type').kind_of?(Astm::Sastm::RDBString)) then
      return SQLStringType
    end
    if (self.get('type') && self.get('type').kind_of?(Astm::Sastm::RDBInt)) then 
      return SQLIntegerType
    end
    if (self.get('type') && self.get('type').kind_of?(Astm::Sastm::RDBFloat)) then
      return SQLFloatType
    end
    if (self.get('type') && self.get('type').kind_of?(Astm::Sastm::RDBTimestamp)) then
      return SQLDateType
    end
    if (self.get('type') && self.get('type').kind_of?(Astm::Sastm::RDBBoolean)) then 
      return SQLBooleanType
    end
    if (self.get('type') && self.get('type').kind_of?(Astm::Sastm::RDBBFile)) then
      return SQLBitString
    end
    if (self.get('type') && self.get('type').kind_of?(Astm::Sastm::RDBLong)) then 
      return SQLIntegerType
    end
    if (self.get('type') && self.get('type').kind_of?(Astm::Sastm::RDBRowid)) then
      return SQLStringType
    end
  end
end