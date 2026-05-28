{$zerobasedstrings}
uses MLABC, DataFrameABCCore, System.Text.RegularExpressions;

const markColumnNames = ['экзамен', 'добор 1', 'добор 2', 'пересдача 1', 'пересдача 2', 'бонус'];
const examScoreColumns = ['экзамен', 'пересдача 1', 'пересдача 2'];
const termScoreColumns = ['рейтинг в семестре', 'добор 1', 'добор 2', 'бонус'];

begin
  var dataText := ReadAllText('..\data\УспеваемостьМехмат2017-2025.csv', System.Text.Encoding.UTF8);
  
  // Исправляем строки, которые поделились на две
  dataText := Regex.Replace(dataText, '\r\n",', '",');
  
  var df := DataFrame.FromCsvText(dataText);
  
  // Все колонки в LowerCase
  df.Schema.ColumnNames.ForEach(colName -> begin df := df.Rename(colName, colName.ToLower()); end);
  
  // Удаляем студентов без id
  df := df.Filter(row -> row.IsValid('id студента'));
  
  // Добавляем столбец с общим баллом студента по дисциплине:
  // сумма баллов за работу в семестре и доборы + максимальный балл за все попытки сдачи экзамена
  df := df.WithColumnInt('общий балл', row -> termScoreColumns.Sum(name -> row.Int(name)) + 
    examScoreColumns.Max(name -> row.Int(name)));
    
  // Выделим список специльностей Мехмата - они многократно отличаются
  // количеством записей от специальностей других факультетов
  var specNames := df.GroupBy('название специальности').Count
  .Filter(row -> row.Int('count') > 1000).GetStrColumn('название специальности');
  
  // Выделим список дисциплин, по которым отсутствуют баллы у студентов Мехмата
  var emptyScoreDisciplines := df.Filter(row -> specNames.Contains(row.Str('название специальности')))
  .GroupBy('дисциплина').Sum('общий балл').Filter(row -> row.Float('общий балл_sum') = 0)
  .GetStrColumn('дисциплина');
  
  // Удалим записи о тех дисциплинах, по которым отсутвуют баллы у студентов Мехмата
  Println($'Кол-во записей до очистки по пустым оценкам: {df.RowCount()}');
  df := df.Filter(row -> specNames.Contains(row.Str('название специальности')) and 
  not emptyScoreDisciplines.Contains(row.Str('дисциплина')) or not specNames.Contains(row.Str('название специальности')));
  Println($'Кол-во записей после очистки: {df.RowCount()}');

end.