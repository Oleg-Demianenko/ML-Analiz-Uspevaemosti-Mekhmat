uses MLABC, DataFrameABCCore;

const markColumnNames = ['экзамен', 'добор 1', 'добор 2', 'пересдача 1', 'пересдача 2', 'бонус'];

begin
  var df := DataFrame.FromCsv('..\data\УспеваемостьМехмат2017-2025.csv');
  
  // Все колонки в LowerCase
  df.GetColumns.Select(col -> col.Info.Name)
    .ForEach(colName -> begin df := df.Rename(colName, colName.ToLower()); end);
  
  // Удаляем строки со всеми пустыми оценками
  Println($'Кол-во записей до очистки по пустым оценкам: {df.RowCount()}');
  df := df.Filter(r -> markColumnNames.Any(name -> r.Int(name) > 0));
  Println($'Кол-во записей после очистки: {df.RowCount()}');

  
end.