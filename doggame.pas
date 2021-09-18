uses crt;

var
  x, y, vx, vy, score, fx, fy, speed, lifes: integer;
  ch: char;

//рисуются границы (рамка) вокруг игрового поля
function drawBorder(): integer;
var
  i: integer;
begin
  for i := 1 to 80 do
  begin
    gotoxy(i, 1);
    write('X');
  end;
  
  for i := 1 to 80 do
  begin
    gotoxy(i, 25);
    write('X');
  end;
  
  for i := 1 to 25 do
  begin
    gotoxy(1, i);
    write('X');
  end;
  
  for i := 1 to 25 do
  begin
    gotoxy(80, i);
    write('X');
  end;
end;

//В случайном месте спаунит еду для "собачки"
function spawnFood(): integer;
begin
  fx := random(76) + 2;
  fy := random(21) + 2;
  gotoxy(fx, fy);
  write('O');
end;

//функия отображения счета
//показывает счет игрока в нижне сроке
function showScore(): integer;
begin
  gotoxy(35, 25);
  write(score);
end;

//Функция отвечает за "поедание еды"
//если координаты (х, у) "собачки" совпадают с координатами "еды" (функция spawnFood),
//то счет увеличивается на 1, вызывется функия отображения счета (showScore)
//вызывается spawnFood для спауна еды на новом месте
//стирается "съеденная" еда
//После съедения каждых 5 штук (если score кратен 5) – скорость увеличивается 1 
//(но не более, чем в 5 раз от начальной).

function eatFood(): integer;
begin
  if (fx = x) and (fy = y) then begin
    gotoxy(fx, fy);
    write(' ');
    score := score + 1;
    showScore();
    spawnFood();
    if (score mod 5 = 0) and (speed >= 25) then speed := speed - 15;
  end;
end;

//фунция самой игры, отвечает за движения игрока (собачки)
//собачка отображается по координатам х и у
//игра начинается по нажатию любой клавиши
//при нажатии клави 'w', 'a', 's', 'd' игрок совершает движения в заданном направлении на 1 позицию
//(vx и vy увеличиваются на 1 или -1 или остаются 0) 
//х и у увеличиваюся на значения  vx и vy
//старое место отрисовки собачки стирается (заменяется на пустую строку)
//вызывается функция eatFood и отображается количество оставшихся жизней
//функция game выполняется до тех пор, пока собачка не коснется стенок - 
//(x >= 2) and (x <= 79) and (y >= 2) and (y <= 24)
//если коснулась стены - количество жизней уменьшается на 1 и функция завершается

function game(): integer;
begin
  while (x >= 2) and (x <= 79) and (y >= 2) and (y <= 24) do
  begin
    gotoxy(x, y);
    write('@');
    delay(speed);
    if keypressed then begin
      ch := readkey;
      case ch of
        'd': begin vx := 1; vy := 0 end;
        'a': begin vx := -1; vy := 0 end; 
        'w': begin vx := 0; vy := -1 end; 
        's': begin vx := 0; vy := 1 end; 
      end;
    end;
    gotoxy(x, y);
    write(' ');
    inc(x, vx);
    inc(y, vy);
    eatFood();
    gotoxy(25, 25);
    write(lifes);
    gotoxy(15, 25);
    write(x, y);
  end;
  lifes := lifes - 1;
end;

begin
  clrscr;
  speed := 80;
  score := 0;
  lifes := 5;
  
//рисуются границы (рамка) вокруг игрового поля
  drawBorder();
//  showScore();
  
  x := 40;
  y := 25 div 2;
  
  //спаунится еда в случайном месте
  spawnFood();
  
  //пока жизней больше 5 игра продолжается
  while lifes > 0 do
  begin
    
    game();
    
    //собачка возвращается в центр игрового поля
    x := 40;
    y := 25 div 2;
  
  end;  
  
  //выводится сообщение о окончании игры и счет
  gotoxy(40, 10);
  write('Игра окончена!');
  gotoxy(40, 12);
  write('score: ' + score);
  
end.