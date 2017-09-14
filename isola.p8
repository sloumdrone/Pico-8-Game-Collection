--isola
--by sloum

---------------------------------------objects and variables--------------------
function _init()
  tick = 0
  p1 = {x = 32, y = 0, sp = 5, isola = false, move = 0, destroy = 0}
  p2 = {x = 32, y = 64, sp = 7, isola = false, move = 0, destroy = 0}
  cursor = {x = 32, y= 32, sp = 9, visible = false}
  phase = 'movement'
  --movement
  --destruction
  --endgame
  currentplayer = p1
  menuselection = {x = 20, y = 30}
  
  legalmoves = {}
  cpulegalforcompare = {}
  
  game_mode = 3
  --0 = human v cpu
  --1 = human v human
  --2 = rules
  --3 = menu

  time1 = 0
  time2 = 0

endtheme = 0
end

-----------------------------------------functions------------------------------
function remove_tile(itemx,itemy)
  local xx = flr(itemx/8)
  local yy = flr(itemy/8)
  if not ((itemx == p1.x) and (itemy == p1.y)) then
    if not((itemx == p2.x) and (itemy == p2.y)) then
      if fget(mget(xx,yy),0) then
        mset(xx,yy,3)
        mset(xx+1,yy,4)
        mset(xx,yy+1,19)
        mset(xx+1,yy+1,20)
        currentplayer.destroy = 1
        phase = 'movement'
      end
    end
  end
end

function move_player()
  if ((cursor.y >= currentplayer.y - 16) and (cursor.y <= currentplayer.y + 16)) and ((cursor.x >= currentplayer.x - 16) and (cursor.x <= currentplayer.x + 16)) then
    if not fget(mget(flr(cursor.x/8),flr(cursor.y/8)),1) then
      if mget(currentplayer.x/8,currentplayer.y/8) == 3 then
        mset(currentplayer.x/8,currentplayer.y/8,3)
      else
        mset(currentplayer.x/8,currentplayer.y/8,1)
      end
      currentplayer.x = cursor.x
      currentplayer.y = cursor.y
      sfx(0)
      mset(currentplayer.x/8,currentplayer.y/8,52)
      currentplayer.move = 1
    else
      sfx(2)
    end
  else
    sfx(2)
  end
end

function time()
  time1 = flr(rnd(60)+15)
  time2 = time1 + 30
end

function getlegalmoves(a,b,tablechoice)
  local xx = flr(a/8)
  local yy = flr(b/8)
  local lm = {}
  if fget(mget(xx-2,yy),0) then
    lm = {x = a-16, y = b, points = 0}
    add(tablechoice,lm)
    lm = {}
  end
  if fget(mget(xx+2,yy),0) then
    lm = {x = a+16, y = b, points = 0}
    add(tablechoice,lm)
    lm = {}
  end
  if fget(mget(xx-2,yy-2),0) then
    lm = {x = a-16, y = b-16, points = 0}
    add(tablechoice,lm)
    lm = {}
  end
  if fget(mget(xx+2,yy-2),0) then
    lm = {x = a+16, y = b-16, points = 0}
    add(tablechoice,lm)
    lm = {}
  end
  if fget(mget(xx-2,yy+2),0) then
    lm = {x = a-16, y = b+16, points = 0}
    add(tablechoice,lm)
    lm = {}
  end
  if fget(mget(xx+2,yy+2),0) then
    lm = {x = a+16, y = b+16, points = 0}
    add(tablechoice,lm)
    lm = {}
  end
  if fget(mget(xx,yy+2),0) then
    lm = {x = a, y = b+16, points = 0}
    add(tablechoice,lm)
    lm = {}
  end
  if fget(mget(xx,yy-2),0) then
    lm = {x = a, y = b-16, points = 0}
    add(tablechoice,lm)
    lm = {}
  end
end

function choosebestmove()
  local pointdistro = {}
  for move in all(legalmoves) do
    getlegalmoves(move.x,move.y,pointdistro)
    move.points = #pointdistro
    pointdistro = {}
  end
  bestscore = maxpoints(legalmoves)

  for goodmove in all(legalmoves) do
    if goodmove.points < bestscore then
      del(legalmoves,goodmove)
    end
  end
  aimove = legalmoves[flr(rnd(#legalmoves)+1)]
end

function choosebestdestroy()
  local pointdistro = {}

  if #legalmoves > 0 then --if p1 has 1 or more legal moves
    for destruction in all(legalmoves) do
      getlegalmoves(destruction.x,destruction.y,pointdistro)
      destruction.points = #pointdistro
      pointdistro = {}
    end
    getlegalmoves(p2.x,p2.y,cpulegalforcompare)
    if #cpulegalforcompare > 0 then
      for p2move in all(cpulegalforcompare) do
        for p1move in all(legalmoves) do
          if ((p1move.x == p2move.x) and (p1move.y == p2move.y)) then
            p1move.points -= 2
            if p1move.points < 0 then
              p1move.points = 0
            end
          end
        end
      end
    end  
    cpulegalforcompare = {}
    bestscore = maxpoints(legalmoves)
    for goodmove in all(legalmoves) do
      if goodmove.points < bestscore then
        del(legalmoves,goodmove)
      end
    end
    aimove = legalmoves[flr(rnd(#legalmoves)+1)]
  else --chooses a random available tile if the opponent is fully surrounded. occurs when the ai blocks their last place.
    for i=0,4 do
      for j=0,4 do
        if mget((i*16)/8,(j*16)/8) == 1 then
          aimove = {x = i*16, y = i*16, points = 1}
          break
        end
      end
    end
  end
end

function maxpoints(tablename)
  local bignum = 0
  if #tablename != 0 then 
    if #tablename < 2 then
      for item in all(tablename) do
        bignum = max(bignum,item.points)
      end
      return bignum
    else
      for item in all(tablename) do
        bignum = max(bignum,item.points)
      end
      return bignum
    end
  end
end

function reset_map() --experimental
  for i=1,18,2 do -- x
    for j=1,16,2 do -- y
      if mget(i-1,j-1) == 52 then
        mset(i-1,j-1,1)
        mset(i,j-1,2)
        mset(i-1,j,17)
        mset(i,j,18)
      elseif mget(i-1,j-1) == 3 then
        if ((i-1 == 4) and (j-1 == 0)) or ((i-1 == 4) and (j-1 == 8)) then
          mset(i-1,j-1,3)
        else
          mset(i-1,j-1,1)
          mset(i,j-1,2)
          mset(i-1,j,17)
          mset(i,j,18)
        end
      end
    end
  end
end
          
        

function controls()
  --check to see if game is over
  if game_mode == 0 or game_mode == 1 then
    getlegalmoves(currentplayer.x,currentplayer.y,legalmoves) 
    if #legalmoves < 1 or legalmoves == nil then
      phase = 'endgame'
      if endtheme == 0 then
        music(2)
        endtheme+=1
      end
    end
    legalmoves = {}
  end

  --if not, allow play
  if phase != 'endgame' then
    if btnp(0)  then
      if cursor.x - 16 > -1 then
        cursor.x -= 16
      end
    end
    if btnp(1) then
      if cursor.x + 16 < 80 then
        cursor.x += 16
      end
    end
    if btnp(2) then
      if cursor.y - 16 > -1 then
        cursor.y -= 16
      end
    end
    if btnp(3) then
      if cursor.y + 16 < 80 then
        cursor.y += 16
      end
    end
    if btnp(5) or btnp(4) then
      if currentplayer.move < 1 then
        move_player()
      elseif currentplayer.move > 0 and currentplayer.destroy < 1 then
        remove_tile(cursor.x,cursor.y)
        sfx(1)
      end
    end
  else
    if btnp(5) or btnp(4) then
      sfx(10)
      reset_map()
      _init()
    end
  end
end

function draw_menu()
  rectfill(18,60,110,95,2)
  rect(18,60,110,95,8)
  spr(65,35,25,7,3,false,false)
  print('1 player (vs cpu)',31,66,1)
  print('1 player (vs cpu)',30,65,10)
  print('2 player',31,76,1)
  print('2 player',30,75,10)
  print('rules/info',31,86,1)
  print('rules/info',30,85,10)
  print('\143',menuselection.x+1,menuselection.y+1,1)
  print('\143',menuselection.x,menuselection.y,8)
end

function update_menu()
  
  if btnp(2) then
    menuselection.y-=10
    sfx(9) 
  end
  if btnp(3) then
    menuselection.y+=10
    sfx(9)  
  end
  if btnp(4) or btnp(5) then
    sfx(8)
    if menuselection.y == 65 then
      game_mode = 0
    elseif menuselection.y == 75 then
      game_mode = 1
    elseif menuselection.y == 85 then
      game_mode = 2
    end
    
  end
  if menuselection.y < 65 then
    menuselection.y = 65
  elseif menuselection.y > 85 then
    menuselection.y = 85
  end
end

function update_rules()
  if btnp(0) or btnp(1) or btnp(2) or btnp(3) or btnp(4) or btnp(5) then
    sfx(10)
    _init()
  end
end

function draw_rules()
  print('isola rules:',0,1,14)
  print('on your turn move one space in\nany direction. after moving,\nremove an unoccupied tile from\nanywhere on the board. only one\nplayer can occupy a tile at a\ntime. the first player that cant\nmove their piece on their turn\nloses the game.',0,11,12)
  print('controls:',0,65,14)
  print('up-down-left-right: select tile\nx or z: confirm move/destruction',0,75,12)
  print('credits:',0,98,14)
  print('ported to pico-8/coded\nby sloum (brian evans), 2017',0,108,12)
end

------------------------------------------game loops----------------------------
function _update()  
  if game_mode == 3 then
    update_menu()
  elseif game_mode == 2 then
    update_rules()
  else
    if phase != 'endgame' then
      if game_mode < 1 then
        if currentplayer == p1 then
          cursor.visible = true
          controls()
        else
          --this controlls the ai
          tick += 1
          cursor.visible = false
          if tick == 1 then
            getlegalmoves(p2.x,p2.y,legalmoves) --for movement
            if #legalmoves < 1 or legalmoves == nil then
              phase = 'endgame'
            else
              choosebestmove()
              if mget(currentplayer.x/8,currentplayer.y/8) == 3 then
                mset(currentplayer.x/8,currentplayer.y/8,3)
              else
                mset(currentplayer.x/8,currentplayer.y/8,1)
              end
            end
            time()
          elseif tick == time1 then
            currentplayer.x = aimove.x
            currentplayer.y = aimove.y
            mset(currentplayer.x/8,currentplayer.y/8,52)
            currentplayer.move = 1
            legalmoves = {}
            sfx(0)
          elseif tick >= time2 then
            getlegalmoves(p1.x,p1.y,legalmoves) --for destruction
            choosebestdestroy()
            remove_tile(aimove.x,aimove.y)  
            legalmoves = {}
            sfx(1)
            tick = 0
          end
        end
      else
        cursor.visible = true
        controls()
      end
      if currentplayer.move > 0 and currentplayer.destroy < 1 then
        phase = 'destruction'
      elseif currentplayer.move > 0 and currentplayer.destroy > 0 then
        currentplayer.move = 0
        currentplayer.destroy = 0
        if currentplayer == p1 then
          currentplayer = p2
        else
          currentplayer = p1
        end
      end
    else
      controls()
    end
  end
end

function _draw()
  cls()
  if game_mode == 3 then
    draw_menu()
  elseif game_mode == 2 then
    draw_rules()
  else
    map(0,0,0,0,11,11)
    spr(65,80,104,6,3,false,false)
    spr(p1.sp,p1.x,p1.y,2,2,false,false)
    spr(p2.sp,p2.x,p2.y,2,2,false,false)
    if cursor.visible then
      spr(cursor.sp,cursor.x,cursor.y,2,2,false,false)
    end

    if currentplayer == p1 then
      if phase == 'endgame' then
        print('player 2 wins!!\npress (x) to restart',3,91,2)
        print('player 2 wins!!\npress (x) to restart',2,90,14)
      else
        print("p1's turn: "..phase,3,91,1)
        print("p1's turn: "..phase,2,90,13)
      end
    else
      if phase == 'endgame' then
        print('player 1 wins!!\npress (x) to restart',3,91,1)
        print('player 1 wins!!\npress (x) to restart',2,90,13)
      else
        print("p2's turn: "..phase,3,91,2)
        print("p2's turn: "..phase,2,90,14)
      end
    end
  end
end
