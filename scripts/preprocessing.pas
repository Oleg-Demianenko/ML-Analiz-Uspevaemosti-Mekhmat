{$zerobasedstrings}
uses MLABC, DataFrameABCCore, System.Text.RegularExpressions;

const markColumnNames = ['экзамен', 'добор 1', 'добор 2', 'пересдача 1', 'пересдача 2', 'бонус'];

begin
  var dataText := ReadAllText('..\data\УспеваемостьМехмат2017-2025.csv', System.Text.Encoding.UTF8);
  
  // Исправляем строки, которые поделились на две
  dataText := Regex.Replace(dataText, '\n",', '",');
  
  var df := DataFrame.FromCsvText(dataText);
  
  // Все колонки в LowerCase
  df.GetColumns.Select(col -> col.Info.Name)
    .ForEach(colName -> begin df := df.Rename(colName, colName.ToLower()); end);
  
  // Удаляем строки со всеми пустыми оценками
  Println($'Кол-во записей до очистки по пустым оценкам: {df.RowCount()}');
  df := df.Filter(r -> markColumnNames.Any(name -> r.IsValid(name)));
  Println($'Кол-во записей после очистки: {df.RowCount()}');

  
end.