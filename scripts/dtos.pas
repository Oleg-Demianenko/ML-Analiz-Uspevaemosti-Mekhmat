unit DTOS;

type ValidationException = class(Exception) end;

type Student = record
  
  id: integer;
  
  enrollYear: word;
  
  meanScore: single;
  
  specCode: string;
  
  wasBachelor: boolean;
  
  wasMaster: boolean;
  
  transferedToMMCS: boolean;
  
  transferedFromMMCS: boolean;
  
  changedSpecialty: boolean;
  
  repeatedYear: boolean;
  
  repeatedYearsCount: byte;
  
  expelled: boolean;
  
  meanScoresForSemester: array of single;
  
  procedure SetId(val: integer);
  begin
    if val < 0 then 
      raise new ValidationException('ID must be >= 0');
    
    id := val;
  end;
  
  procedure SetEnrollYear(val: word);
  begin
    if (val < 2017) or (val > 2025) then
      raise new ValidationException('Enrollment year is out of bounds');
    
    enrollYear := val;
  end;
  
  procedure SetMeanScore(val: single);
  begin
    if val < 0.0 then 
      raise new ValidationException('Mean score < 0.0');
    
    meanScore := val;
  end;
  
  procedure SetSpecCode(val: string);
  begin
    if val = '' then 
      raise new ValidationException('Specialty code cannot be empty');
    
    specCode := val;
  end;
  
  procedure SetWasBachelor(val: boolean);
  begin
    wasBachelor := val;
  end;
  
  procedure SetWasMaster(val: boolean);
  begin
    wasMaster := val;
  end;
  
  procedure SetTransferedToMMCS(val: boolean);
  begin
    transferedToMMCS := val;
  end;
  
  procedure SetTransferedFromMMCS(val: boolean);
  begin
    transferedFromMMCS := val;
  end;
  
  procedure SetChangedSpecialty(val: boolean);
  begin
    changedSpecialty := val;
  end;
  
  procedure SetRepeatedYear(val: boolean);
  begin
    repeatedYear := val;
  end;
  
  procedure SetRepeatedYearsCount(val: byte);
  begin
    if (val > 5) then 
      raise new ValidationException('Repeated years count cannot exceed 5');
    
    repeatedYearsCount := val;
  end;
  
  procedure SetExpelled(val: boolean);
  begin
    expelled := val;
  end;
  
  procedure SetMeanScoresForSemester(val: array of single);
  begin
    if val = nil then
      raise new ValidationException('Array cannot be nil');
    
    foreach var score in val do
      if score < 0.0 then
        raise new ValidationException('Mean score for semester < 0.0');
    
    meanScoresForSemester := val;
  end;
  
end;


end.