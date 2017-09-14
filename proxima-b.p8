-- proxima b
-- by sloum

function _init()
  --counters
  score = 6500
  tick = 0
  endgame_y = 0
  hypertick = 0
  win = false
  --player
  ship = {sp=16,x=60,y=115,en=0,dbl=0,box={x1=1,y1=0,x2=6,y2=7}}
  weaponry = {}
  powerups = {}
  tail = {}

  cam = {}
  cam.x = 0
  cam.y = 0
  isonground = false
  convo = 0
  --ai
  enemies = {}
  enemyweaponry = {}
  boss1 = {sp=130,x=17,y=-50,xadd=48,health=155}
  boss1gun1 = {sp=997,x=37,y=24,en=55,col=1,row=1,box={x1=-5,y1=-5,x2=4,y2=0}}
  boss1gun2 = {sp=999,x=94,y=24,en=55,col=1,row=1,box={x1=-4,y1=-5,x2=5,y2=0}}
  bossmouth = {sp=998,x=64,y=21,en=45,col=1,row=1,box={x1=-4,y1=-1,x2=4,y2=3}}
  bossgunlsp = {sp=164,x=33,y=-34,col=1,row=1,xadd=48}
  bossgunrsp = {sp=164,x=89,y=-34,col=1,row=1,xadd=48}
  bossmouthsp = {sp=166,x=48,y=-34,col=1,row=1}
  bossenemies = {boss1gun1,boss1gun2,bossmouth}

  --visuals
  stars = {}
  clouds = {}
  explosions = {}
  hyper = {}
  hship = {sp=16,x=60,y=140}

  --controls
  max_wave = 3
  title = true


  --create star field
  for i=1,128 do
    add(stars,{x=rnd(128),
    y=rnd(128),
    s=rnd(5)+1})
  end

  --create hyperspace field
  for i=1,100 do
    if flr(rnd(1.99)) == 1 then
      col=7
    else
      col=12
    end
    add(hyper,{x=rnd(128),
    y=rnd(128),
    s=rnd(20)+3,
    l=rnd(105),
    c=col})
  end

  for i=1,3 do
    shiptail()
  end


  --start the game
  chapterscreen()
end

level = 0

--game state functions
function loadlevel()
  if level == 0 then
    music(0)
    _update = update_hyperspace
    _draw = draw_hyperspace
  elseif level == 1 then
    score = 6500
    tick = 0
    music(30,800)
    _update = update_level1
    _draw = draw_level1
  elseif level == 1.5 then
    --music(8,600)
    tick = 0
    _update = update_bossfight1
    _draw = draw_bossfight1
  elseif level == 2 then
    enemies = {}
    music(59,800,7)
    score = 6500
    tick = 0
    for i=1,15 do -- this was 20
      cloudcraft()
    end
    stars = {}
    for i=1,100 do
      add(stars,{
        x=rnd(128),
        y=rnd(128),
        s=rnd(1.5)+0.5,
        co=14})
    end
    _update = update_level2
    _draw = draw_level2
  elseif level == 2.5 then
    enemies = {}
    music(50,800)
    add(enemies,{sp=138,x=64,y=-35,health=150,r=40,m_x=30,col=4,row=4,agro=false,box={x1=5,y1=8,x2=54,y2=17}})
    tick = 0
    for i=1,15 do -- this was 20
      cloudcraft()
    end
    stars = {}
    for i=1,100 do
      add(stars,{
        x=rnd(128),
        y=rnd(128),
        s=rnd(1.5)+0.5,
        co=14})
    end
    _update = update_bossfight2
    _draw = draw_bossfight2
  elseif level == 3 then
    sm = {sp=18,x=10,y=10,en=50,reverse=false,speed=2,fuel=104,visible=true,box={x1=1,y1=0,x2=5,y2=7}}
    music(40,600)
    tick = 0
    _update = update_level3
    _draw = draw_level3
  end
end


function chapterscreen()
  weaponry = {}
  powerups = {}
  enemies = {}
  enemyweaponry = {}
  tick = 0
  endgame_y = 0
  score = 6500
  _update = update_chapter
  _draw = draw_chapter
end

function update_chapter()
  if level == 0 then
    loadlevel()
  else
    if tick <= 1 then
      music(-1,800)
    end
    tick += 1
    if tick == 70 then
      sfx(11)
    end
    if tick == 90 then
      loadlevel()
    end
  end
end

function draw_chapter()
  cls()
  if level == 1 or level == 1.5 then
    print('chapter 1',49,105,6)
    print('coming out of hyperspace',30,111,12)
  elseif level == 2 or level == 2.5 then
    print('chapter 2',49,105,6)
    print('the rings of proxima',30,111,14)
  elseif level == 3 then
    print('chapter 3',49,105,6)
    print('proxima-b',65,111,9)
  end
end


function game_over()
  music(-1)
  sfx(8)
  _update = update_over
  _draw = draw_over
  tick = 0
end

function update_over()
  if endgame_y < 41 then
    endgame_y += 1
  end

  if tick > 5 then
    if btnp(5) then
      ship = {sp=16,x=60,y=115,en=0,dbl=0,box={x1=2,y1=0,x2=5,y2=7}}
      weaponry = {}
      powerups = {}
      enemies = {}
      clouds = {}
      explosions = {}
      enemyweaponry = {}
      boss1 = {sp=130,x=17,y=-50,xadd=48,health=100}
      boss1gun1 = {sp=997,x=37,y=24,en=30,col=1,row=1,box={x1=-5,y1=-5,x2=4,y2=0}}
      boss1gun2 = {sp=999,x=94,y=24,en=30,col=1,row=1,box={x1=-4,y1=-5,x2=5,y2=0}}
      bossmouth = {sp=998,x=64,y=21,en=40,col=1,row=1,box={x1=-4,y1=-1,x2=4,y2=3}}
      bossgunlsp = {sp=164,x=33,y=-34,col=1,row=1,xadd=48}
      bossgunrsp = {sp=164,x=89,y=-34,col=1,row=1,xadd=48}
      bossmouthsp = {sp=166,x=48,y=-34,col=1,row=1}
      bossenemies = {boss1gun1,boss1gun2,bossmouth}
      chapterscreen()
    end
  end
  tick += 1
end

function draw_over()
  if endgame_y < 41 then
    print('game over',45,endgame_y,8)
  end
  if endgame_y == 40 then
    print('game over',46,41,10)
  end
  if tick > 5 then
    print('insert coin (x) to continue...',8,110,6)
  end
end




---game play functions: fire, collision, etc

function shiptail()
  local t = {}
  t.x = rnd(4)+2
  t.y = rnd(4)+8
  t.r = rnd(3)
  t.c = flr(rnd(16))+1
  add(tail,t)
end

function movesomethings()
  --stars, ship tail, powerups, enemy bullets,ship powerup toggles
  if level < 3 then
    for st in all(stars) do
      st.y += st.s
      if st.y > 128 then
        st.y = 0
        st.x = rnd(128)
      end
      if st.s < 1 then
        st.co = 5
      else
        st.co = 6
      end
    end
  end

  for t in all(tail) do
    if tick % 2 == 0 then
      t.y += 1
      t.r += 1
      if t.r > 3 then
        del(tail,t)
        shiptail()
      end
    end
  end

  for ex in all(explosions) do
    ex.t += 1
    if ex.size == 0 then
      if ex.t == 5 then
        del(explosions,ex)
      end
    elseif ex.size == 1 then
      if ex.t == 15 then
        del(explosions,ex)
      end
    end
  end

  if ship.dbl <= 0 and ship.en <= 0 then
    ship.sp = 16
  else
    ship.sp = 32
  end
  if ship.en < 0 then
    ship.en = 0
  end
  if ship.dbl < 0 then
    ship.dbl = 0
  end

  --move and delete enemy bullets
  for ew in all(enemyweaponry) do
    ew.x += ew.dx
    ew.y += ew.dy
    if ew.x < 0 or ew.y < 0 or
    ew.x > 128 or ew.y > 128 then
      del(enemyweaponry,ew)
    end
    if ew.dx == 0 and ew.dy == 0 then
      del(enemyweaponry,ew)
    end
    if coll(ew,ship) then
      if not shield then
        game_over()
      end
    end
  end

  for p in all(powerups) do --move and delete all powerups
    p.y += p.m_y
    if coll(p,ship) then
      if p.sp == 39 then
        ship.en = 100
      else
        ship.dbl = 100
      end
      del(powerups,p)
      sfx(32)
    end
    if p.y > 128 then
      del(powerups,p)
    end
  end
end

function cloudcraft()
  local seed = flr(rnd(101))
  local c = {}
  if  seed <= 75 then
    if flr(rnd(2)) == 1 then
      c.x = 0
    else
      c.x = 128
    end
    c.y = flr(rnd(128))-256
    c.s = flr(rnd(3.5))+ 1
    c.r = flr(rnd(40))+5
    c.redraw = false
    if c.s < 2 then
      c.co = 13
      c.po = 1
    else
      c.co = 15
      c.po = 2
    end
    add(clouds,c)
  elseif seed > 75 and seed < 95 then
    if flr(rnd(2)) == 1 then
      c.x = 0
    else
      c.x = 128
    end
    c.y = flr(rnd(128))-256
    c.s = flr(rnd(3.5))+ 1
    c.r = flr(rnd(40))+5
    c.redraw = false
    c.co = 15
    c.po = 3
    add(clouds,c)
  else
    c.x = rnd(128)
    c.y = flr(rnd(128))-256
    c.s = flr(rnd(3.5))+ 1
    c.r = flr(rnd(22))+5
    c.redraw = true
    if c.s < 2 then
      c.co = 13
      c.po = 1
    else
      c.co = 15
      if rnd(2) > 0.99 then
        c.po = 2
      else
        c.po = 3
      end
    end
    add(clouds,c)

  end
end

function fire(source)
  if source == ship then
    if source.en > 0 and source.dbl > 0 then
      local b = {
        sp = 22,
        x = source.x,
        y = source.y,
        dx = 0,
        dy = -3,
        box={x1=2,y1=0,x2=5,y2=2}
      }
      add(weaponry,b)
      local b = {
        sp = 22,
        x = source.x,
        y = source.y,
        dx = -2,
        dy = -3,
        box={x1=2,y1=0,x2=5,y2=2}
      }
      add(weaponry,b)
      local b = {
        sp = 22,
        x = source.x,
        y = source.y,
        dx = 2,
        dy = -3,
        box={x1=2,y1=0,x2=5,y2=2}
      }
      add(weaponry,b)
    elseif source.en > 0 then
      local b = {
        sp = 6,
        x = source.x,
        y = source.y,
        dx = 0,
        dy = -3,
        box={x1=2,y1=0,x2=3,y2=1}
      }
      add(weaponry,b)
      local b = {
        sp = 6,
        x = source.x,
        y = source.y,
        dx = -2,
        dy = -3,
        box={x1=2,y1=0,x2=3,y2=1}
      }
      add(weaponry,b)
      local b = {
        sp = 6,
        x = source.x,
        y = source.y,
        dx = 2,
        dy = -3,
        box={x1=2,y1=0,x2=3,y2=1}
      }
      add(weaponry,b)
    elseif source.dbl > 0 then
      local b = {
        sp = 22,
        x = source.x,
        y = source.y,
        dx = 0,
        dy = -3,
        box={x1=2,y1=0,x2=5,y2=2}
      }
      add(weaponry,b)
    else
      local b = {
        sp = 6,
        x = source.x,
        y = source.y,
        dx = 0,
        dy = -3,
        box={x1=2,y1=0,x2=3,y2=1}
      }
      add(weaponry,b)
    end
  elseif source.sp == 35 then
    local b = {
      sp = 51,
      x = source.x+(source.col*4),
      y = source.y+(source.row*4),
      dx = flr(rnd(8))-4,
      dy = flr(rnd(5))-2,
      box={x1=0,y1=0,x2=1,y2=1}
    }
    add(enemyweaponry,b)

  elseif source.sp == 33 or source.sp == 36 then --new
    local b = {
      sp = 38,
      x = source.x,
      y = source.y+(source.row*4+1),
      dx = rnd(1)-0.5,
      dy = 3,
      box={x1=2,y1=0,x2=5,y2=2}
    }
    add(enemyweaponry,b)
  elseif source.sp == 11 or source.sp == 13 then
    local b = {
      sp = 10,
      x = source.x+(source.col/2*8),
      y = source.y+(source.row*8),
      dx = flr(rnd(8))-4,
      dy = flr(rnd(2)) + 2,
      box={x1=0,y1=0,x2=1,y2=1}
    }
    add(enemyweaponry,b)
  elseif source.sp == 34 or source.sp == 3 then --the zigzag yellow guys
    local t
    if source.sp == 3 then
      t = 7
    else
      t = 21
    end
    local b = {
      sp = t,
      x = source.x+4,
      y = source.y+4,
      dx = flr(rnd(4))-2,
      dy = flr(rnd(4)),
      box={x1=0,y1=0,x2=0,y2=0}
    }
    add(enemyweaponry,b)
  elseif source.sp == 997 or source.sp == 999 then
    if bossmouth.en > 0 then
      local b = {
        sp = 51,
        x = source.x,
        y = source.y,
        dx = flr(rnd(6))-3,
        dy = flr(rnd(3)) + 1,
        box={x1=0,y1=0,x2=1,y2=1}
      }
      add(enemyweaponry,b)
    else
      local b = {
        sp = 51,
        x = source.x,
        y = source.y,
        dx = flr(rnd(6))-3,
        dy = flr(rnd(3)) + 2,
        box={x1=0,y1=0,x2=1,y2=1}
      }
      add(enemyweaponry,b)
    end
  elseif source.sp == 998 then
    if boss1gun1.en > 0 or boss1gun2.en > 0 then
      local b = {
        sp = 43,
        x = source.x+rnd(2),
        y = source.y-3,
        dx = rnd(2)-1,
        dy = 3.25,
        box={x1=2,y1=5,x2=5,y2=7}
      }
      add(enemyweaponry,b)
    else
      local b = {
        sp = 43,
        x = source.x+rnd(2),
        y = source.y-3,
        dx = 0,
        dy = 4,
        box={x1=2,y1=5,x2=5,y2=7}
      }
      add(enemyweaponry,b)
    end
  elseif source.sp == 24 then
    for i=1,10 do
      local b = {
        sp = 26,
        x = source.x+4,
        y = source.y+4,
        dx = flr(rnd(6)-3),
        dy = flr(rnd(4)-1),
        box={x1=0,y1=0,x2=1,y2=1}
      }
      add(enemyweaponry,b)
    end
  elseif source.sp == 25 then
    local b = {
      sp = 23,
      x = source.x+4,
      y = source.y+8,
      dx = 0,
      dy = 3,
      box={x1=0,y1=0,x2=2,y2=2}
    }
    add(enemyweaponry,b)
  elseif source.sp == 138 and source.agro == true then
    for i=1,2 do
      local b = {
        sp = 178,
        x = source.x + rnd(25)+25,
        y = source.y + rnd(10)+8,
        dx = flr(rnd(6)-3),
        dy = rnd(3)+0.5,
        box = {x1=0,y1=0,x2=1,y2=1}
      }
      add(enemyweaponry,b)
    end
    local c = {
      sp = 23,
      x = source.x + rnd(25)+25,
      y = source.y + rnd(10)+8,
      dx = 0,
      dy = 3,
      box={x1=0,y1=0,x2=2,y2=2}
    }
    add(enemyweaponry,c)

  elseif source.sp == 138 and source.agro == false then
    local b = {
      sp = 23,
      x = source.x + rnd(25)+25,
      y = source.y + rnd(10)+8,
      dx = 0,
      dy = 3,
      box={x1=0,y1=0,x2=2,y2=2}
    }
    add(enemyweaponry,b)
  end
end

function move_player()
  if btn(0) then --left
    ship.x-=2
    if ship.x < 0 then
      ship.x = 128
    end
  end
  if btn(1) then --right
    ship.x+=2
    if ship.x > 122 then
      ship.x = 0
    end
  end
  if btn(2) then --up
    ship.y-=3
    if ship.y < -6 then
      ship.y = -6
    end
  end
  if btn(3) then --down
    ship.y+=1.75
    if ship.y > 120 then
      ship.y = 120
    end
  end
  if btnp(5) then
    sfx(0)
    fire(ship)
    if ship.en > 0 then
      ship.en -= 3
    end
    if ship.dbl > 0 then
      if ship.en > 0 then
        ship.dbl -= 3
        ship.en -= 3
      else
        ship.dbl -= 1
      end
    end
  end
end

function explode(x,y,hitorkill)
  --pass hitorkill a 1 (large explosion) or a 0 (small explosion)
  add(explosions,{x=x,y=y,t=0,size=hitorkill})
end

function abs_box(s)
  local box = {}
  box.x1 = s.box.x1 + s.x
  box.y1 = s.box.y1 + s.y
  box.x2 = s.box.x2 + s.x
  box.y2 = s.box.y2 + s.y
  return box
end

function coll(a,b)
  local box_a = abs_box(a)
  local box_b = abs_box(b)

  if box_a.x1 > box_b.x2 or
  box_a.y1 > box_b.y2 or
  box_b.y1 > box_a.y2 or
  box_b.x1 > box_a.x2 then
    return false
  else
    return true
  end
end

function respawn()
  for i=1,max_wave do
    enemytype = flr(rnd(100))+1
    if flr(rnd(10))+1 < 5 then
      diag = 135
      flips = false
    else
      diag = -15
      flips = true
    end
    if level == 1 then
      if enemytype >= 0 and enemytype < 50 then
        add(enemies, {sp = 33, col=1,row=1,health=2, reverse=false, m_x = i * 16, m_y = 20 - i * 8,
        x = flr(rnd(114)) + 7, y = (flr(rnd(100))-8)*-1, r = 12, box={x1=0,y1=3,x2=7,y2=7},
        time=flr(rnd(2))+1,points=175})
      elseif enemytype >= 50 and enemytype < 70 then
        add(enemies, {sp = 34, col=1, row=1, health=1, reverse=false, m_x=i*16, m_y=-20-i*8,
        x=-36, y=-36, r=12, box={x1=1,y1=0,x2=6,y2=7},time=0,points=200})
      elseif enemytype >= 70 and enemytype < 90 then
        add(enemies, {sp = 35, col=1, row=1, health=1, reverse=flips, m_x=1, m_y=1,
        x=diag, y=rnd(40)*-1, r = 12, box={x1=2,y1=1,x2=6,y2=7},
        time=flr(rnd(2))+1,points=225})
      elseif enemytype > 90 and enemytype < 98 and max_wave > 3 then
        add(enemies, {sp = 11, col=2, row=2, health=6, reverse=false, m_x=i*16, m_y=-20-i*8,
        x=flr(rnd(100))+5, y=(flr(rnd(50))*-1)-16, r = 12, box={x1=1,y1=1,x2=14,y2=14},
        time=0,points=300})
      elseif enemytype > 97  and max_wave > 5 and #powerups == 0 then
        if flr(rnd(2)) == 1 then
          add(powerups, {sp=39,x=flr(rnd(119)+1),y=flr(rnd(130))*-1,m_x=0,m_y=1,box={x1=1,y1=0,x2=7,y2=7}})
        else
          add(powerups, {sp=40,x=flr(rnd(119)+1),y=flr(rnd(130))*-1,m_x=0,m_y=1,box={x1=1,y1=0,x2=7,y2=7}})
        end
      end
    elseif level == 2 then
      if enemytype > 94 and #powerups == 0 then
        if flr(rnd(2)) == 1 then
          add(powerups, {sp=39,x=flr(rnd(119)+1),y=flr(rnd(130))*-1,m_x=0,m_y=1,box={x1=1,y1=0,x2=7,y2=7}})
        else
          add(powerups, {sp=40,x=flr(rnd(119)+1),y=flr(rnd(130))*-1,m_x=0,m_y=1,box={x1=1,y1=0,x2=7,y2=7}})
        end
      elseif enemytype > 35 and enemytype < 61 then
        add(enemies, {sp=24,col=1,row=1,health=2, reverse=false, m_x = flr(rnd(70))+16, m_y = flr(rnd(40)) + 5,
        x=flr(rnd(100))+5, y=(flr(rnd(100))*-1)-16, r = flr(rnd(30))+10, box={x1=0,y1=0,x2=7,y2=6},
        time=flr(rnd(2)+1),points=250,counter=0})
      elseif enemytype < 36 then
        for i=1,4 do
          add(enemies, {sp=49,col=1,row=1,health=2, reverse=false, m_x = rnd(2)-1, m_y = 2,
          x=flr(rnd(40))+(i*5), y=(16 + (i*10))*-1, r = flr(rnd(30))+10, box={x1=0,y1=2,x2=7,y2=6},
          time=0,points=75,counter=0})
        end
      elseif enemytype > 60 and enemytype < 76 then
        for c=1,flr(rnd(3)) do
          add(enemies, {sp=25,col=1,row=1,health=1, reverse=false, m_x = flr(rnd(80))+20+(c*8), m_y = 1,
          x=flr(rnd(30))+(c*8), y=(75+(c*24))*-1, r = flr(rnd(10))+10, box={x1=0,y1=3,x2=7,y2=5},
          time=flr(rnd(3))+1,points=200,counter=c})
        end
      elseif enemytype > 85 and enemytype < 95 then
        add(enemies, {sp=3,col=1,row=1,health=2, reverse=flips, m_x=2, m_y=3,
        x=diag, y=-60, r=12, box={x1=0,y1=0,x2=6,y2=6},
        time=3,points=400,counter=0})
      elseif enemytype > 75 and enemytype < 86 then
        add(enemies, {sp = 36, col=1,row=1,health=2, reverse=false, m_x = i * 16, m_y = 20 - i * 8,
        x = flr(rnd(114)) + 7, y = (flr(rnd(100))-8)*-1, r = 12, box={x1=0,y1=3,x2=7,y2=7},
        time=flr(rnd(2))+1,points=175})
      end
    elseif level == 2.5 and i==1 then
      add(enemies, {sp = 35, col=1, row=1, health=1, reverse=flips, m_x=1, m_y=1,
      x=diag, y=rnd(40)*-1, r = 12, box={x1=2,y1=1,x2=6,y2=7},
      time=3,points=225})
    end
  end
end


function update_hyperspace()
  if not title then
    hypertick += 1
  end
  if btnp(5) then
    title = false
  end
  for hy in all(hyper) do
    hy.y += hy.s
    if hy.y > 128 then
      hy.y = 0 - hy.l
      hy.x = rnd(128)
    end
  end
  if hship.y > 90 then
    hship.y -= 0.5
  end
  for t in all(tail) do
    if hypertick % 2 == 0 then
      t.y += 1
      t.r += 1
      if t.r > 3 then
        del(tail,t)
        shiptail()
      end
    end
  end
  if hypertick == 241 then
    level = 1
    chapterscreen()
  end
end



function draw_hyperspace()
  cls()
  if title then
    spr(71,21,25,8,4)
    spr(193,20,40,11,3)
    print('\151 to start',39,105,6)
  else
    for hy in all(hyper) do
      line(hy.x,hy.y,hy.x,hy.y+hy.l,hy.c)
    end
    for t in all(tail) do
      circfill(hship.x+t.x,hship.y+t.y,t.r,t.c)
    end
    spr(hship.sp,hship.x,hship.y)
  end
end


function update_level1() --level 1 loop ----------------------------------------
  shield = false
  tick += 1

  if score > 6000 then
    max_wave = 3
  elseif score > 5000 then
    max_wave = 5
  elseif score > 3800 then
    max_wave = 6
  elseif score > 2000 then
    max_wave = 9
  elseif score > 0 then
    max_wave = 11
  elseif score <= 0 then
    level = 1.5
    music(-1,400)
    loadlevel()
  end

  movesomethings()

  for e in all(enemies) do
    if e.sp == 34 then
      e.m_y += 0.75
      e.x = e.r*sin(tick/50) + e.m_x
      e.y += 1.5
      --e.y = e.r*cos(tick/50) + e.m_y
    elseif e.sp == 33 then --33
      e.y += flr(rnd(2))+1
      if e.y > 1 and e.y < 30 and tick % 13 == 0 and e.time > 0 then
        e.time -= 1
        fire(e)
        sfx(1)
      end
    elseif e.sp == 35 then
      if e.reverse then
        e.x += 1
        e.y += 2
      else
        e.x -= 1
        e.y += 2
      end
      if e.y > 65 and e.time > 0 and tick % 25 then
        e.time -= 1
        fire(e)
        sfx(1)
      end
    elseif e.sp == 11 or e.sp == 13 then
      if e.time == 0 and e.y < 30 then
        e.y += 0.5
      else
        e.time += 1
        if e.time > 60 then
          if e.x > 64 then
            e.x += rnd(6)+3
            e.y += rnd(2)+1
          else
            e.x -= rnd(6)+3
            e.y += rnd(2)+1
          end
        end
      end
      if tick % 2 + flr(rnd(9)) == 0 then
        fire(e)
        sfx(1)
      end
      if tick % 35 == 0 and e.sp == 11 then
        e.sp = 13
      elseif tick % 35 == 0 and e.sp == 13 then
        e.sp = 11
      end
    end
    if coll(ship,e) then
      if not shield then
        game_over()
      end
    end
    if e.y >= 150 then
      del(enemies,e)
    end
  end

  --move and delete player bullets
  for b in all(weaponry) do
    b.x += b.dx
    b.y += b.dy
    if b.x < 0 or b.y < 0 or
    b.x >128 or b.y > 128 then
      del(weaponry,b)
    end




    for e in all(enemies) do
      if coll(b,e) then
        e.y -= 1
        if ship.dbl > 0 then
          e.health -= 2
        else
          e.health -= 1
        end
        explode(b.x,b.y,0)
        del(weaponry,b)
        if e.health <= 0 then
          if e.sp == 34 then
            fire(e)
            fire(e)
            fire(e)
          end
          del(enemies,e)
          explode(e.x+(e.col/2*8)-1,e.y+(e.row/2*8)-1,1)
          score -= e.points
        end
      end

    end
  end

  if #enemies <= 0 then
    respawn()
  end

  move_player()
end --end update function






function draw_level1() --main level draw looploa
  cls()
  --draw stars
  for st in all(stars) do
    if st.s > 3 then
      pset(st.x,st.y,6)
    elseif st.s >= 2 then
      pset(st.x,st.y,5)
    else
      pset(st.x,st.y,1)
    end
  end
  --draw enemies
  for e in all(enemies) do
    spr(e.sp,e.x,e.y,e.row,e.col,e.reverse,false)
  end

  for p in all(powerups) do
    spr(p.sp,p.x,p.y)
  end

  --draw ship tail
  for t in all(tail) do
    circfill(ship.x+t.x,ship.y+t.y,t.r,t.c)
  end
  --draw ship
  spr(ship.sp,ship.x,ship.y)

  --draw bullets
  for b in all(weaponry) do
    spr(b.sp,b.x,b.y)
  end

  --draw enemy bullets
  for ew in all(enemyweaponry) do
    spr(ew.sp,ew.x,ew.y)
  end

  --draw explosions
  for ex in all(explosions) do
    circ(ex.x,ex.y,ex.t/3,8+ex.t%3)
  end

  print((100-(flr(score/6500*100)))..'% to dest.',1,1,6)
end --end draw function


function update_bossfight1() --boss battle!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  tick += 1

  movesomethings()

  --insert boss movement and actions here
  if boss1.health > 0 and boss1.y < 0 then
    boss1.y += 0.5
    bossgunlsp.y += 0.5
    bossgunrsp.y += 0.5
    bossmouthsp.y += 0.5
  end

  if boss1.y == 0 then
    if boss1gun1.en > 0 then
      bossgunlsp.sp = 164
      if tick % 17 == 0 then
        fire(boss1gun1)
        sfx(9)
      end
    else
      bossgunlsp.sp = 162
    end

    if boss1gun2.en > 0 then
      bossgunrsp.sp = 164
      if tick % 13 == 0 then
        fire(boss1gun2)
        sfx(9)
      end
    else
      bossgunrsp.sp = 162
    end


    if bossmouth.en > 0 then
      bossmouthsp.sp = 166
      if boss1gun1.en > 0 or boss1gun2.en > 0 then
        if tick % 45 == 0 then
          fire(bossmouth)
          sfx(10)
        end
      else
        if tick % 27 == 0 then
          fire(bossmouth)
          sfx(10)
        end
      end
    else
      bossmouthsp.sp = 168
    end
  end

  if boss1.health <= 0 then
    if boss1.y > -50 then
      boss1.y -= 0.5
      bossgunlsp.y -= 0.5
      bossgunrsp.y -= 0.5
      bossmouthsp.y -= 0.5
    elseif boss1.y == -50 then
      level = 2
      tick = 0
      enemies = {}
      chapterscreen()
    end
  end
  --end boss movement and actions


  for b in all(weaponry) do
    b.x += b.dx
    b.y += b.dy
    if b.x < 0 or b.y < 0 or
    b.x >128 or b.y > 128 then
      del(weaponry,b)
    end

    for e in all(bossenemies) do
      if coll(b,e) then
        if ship.dbl > 0 then
          e.en -= 2
          boss1.health -= 2
        else
          e.en -= 1
          boss1.health -= 1
        end
        explode(b.x,b.y,0)
        if e.en % 3 == 0 and e.en > 0 then
          sfx(39)
        elseif e.en <= 0 then
          sfx(38)
        end
        del(weaponry,b)
        if e.en <= 0 then
          del(bossenemies,e)
          explode(e.x+(e.col/2*8)-1,e.y+(e.row/2*8)-1,1)
        end
      end

    end
  end

  if  tick % 600 == 0 then
    respawn()
  end

  move_player()
end

function draw_bossfight1()
  cls()
  --draw stars
  for st in all(stars) do
    if st.s > 3 then
      pset(st.x,st.y,6)
    elseif st.s >= 2 then
      pset(st.x,st.y,5)
    else
      pset(st.x,st.y,1)
    end
  end

  for p in all(powerups) do
    spr(p.sp,p.x,p.y)
  end

  for ew in all(enemyweaponry) do
    spr(ew.sp,ew.x,ew.y)
  end

  --boss1 sprite
  spr(boss1.sp,boss1.x,boss1.y,6,2,false,false)
  spr(bossgunlsp.sp,bossgunlsp.x,bossgunlsp.y,1,1,false,false)
  spr(bossmouthsp.sp,bossmouthsp.x,bossmouthsp.y,2,2,false,false)
  spr(bossmouthsp.sp,bossmouthsp.x+16,bossmouthsp.y,2,2,true,false)
  spr(boss1.sp,boss1.x+boss1.xadd,boss1.y,6,2,true,false)
  spr(bossgunrsp.sp,bossgunrsp.x,bossgunrsp.y,1,1,true,false)

  --ship tail and ship
  for t in all(tail) do
    circfill(ship.x+t.x,ship.y+t.y,t.r,t.c)
  end
  spr(ship.sp,ship.x,ship.y)


  for b in all(weaponry) do
    spr(b.sp,b.x,b.y)
  end

  for ex in all(explosions) do
    circ(ex.x,ex.y,ex.t/3,8+ex.t%3)
  end
end


function update_level2()--================================================lvl 2========
  tick += 1

  if score > 6000 then
    max_wave = 3
  elseif score > 5000 then
    max_wave = 4
  elseif score > 3800 then
    max_wave = 5
  elseif score > 2000 then
    max_wave = 6
  elseif score > 0 then
    max_wave = 8
  elseif score <= 0 then
    level = 2.5
    music(-1,400)
    loadlevel()
  end

  for cl in all(clouds) do
    cl.y += cl.s
    if cl.y - cl.r > 128 and cl.redraw then
      cl.x = rnd(128)
      cl.y = rnd(128)-256
      cl.s = flr(rnd(3.5))+ 1
      cl.r = flr(rnd(22))+5
      if cl.s < 2 then
        cl.co = 13
      else
        cl.co = 15
      end
    elseif not cl.redraw and cl.y - cl.r > 128 then
      del(clouds,cl)
      cloudcraft()
    end
  end

  movesomethings()

  if tick > 300 then
    if #enemies <= 0 then
      respawn()
    end
  end

  for e in all(enemies) do
    if e.sp == 24 then
      if e.y < e.m_y then
        if tick > 300 then
          e.x = e.r*sin(tick/50) + e.m_x
          e.y += 1
        end
      elseif e.y == e.m_y then
        e.x = e.r*sin(tick/50) + e.m_x
        e.y += 0
        e.counter += 1
        if e.time > 0 then
          if e.counter % 40 == 0 then
            fire(e)
            e.time -= 1
          end
        else
          e.y += 3
        end
      else
        e.x = e.r*sin(tick/50) + e.m_x
        e.y += 3
      end
    elseif e.sp == 25 then
      e.x = e.r*sin(tick/50) + e.m_x
      e.y += 1
      if e.time > 0 and e.y > 3 then
        if tick % (21 + (e.counter * 13)) == 0 then
          fire(e)
        end
      end
    elseif e.sp == 3 then
      e.counter += 1
      if e.counter >= 60 then
        if e.y < 50 then
          if flips then
            e.x += e.m_x
          else
            e.x -= e.m_x
          end
          e.y += e.m_y
        else
          e.sp = 4
        end
      end
      if e.y > 5 then
        if tick % 20 == 0 then
          if e.time > 0 then
            e.time -= 1
            for i=1,flr(rnd(19))+1 do
              fire(e)
            end
          end
        end
      end
    elseif e.sp == 4 then
      e.y += e.m_y
    elseif e.sp == 49 then
      e.x += e.m_x
      e.y += e.m_y
    elseif e.sp == 36 then --33
      e.y += flr(rnd(2))+1
      if e.y > rnd(30) and e.y < (rnd(30)+30) and e.time > 0 then
        e.time -= 1
        fire(e)
        sfx(1)
      end
    end
    if coll(ship,e) then
      if not shield then
        game_over()
      end
    end
    if e.y >= 150 then
      del(enemies,e)
    end
  end

  --move and delete player bullets
  for b in all(weaponry) do
    b.x += b.dx
    b.y += b.dy
    if b.x < 0 or b.y < 0 or
    b.x >128 or b.y > 128 then
      del(weaponry,b)
    end




    for e in all(enemies) do
      if coll(b,e) then
        e.y -= 1
        if ship.dbl > 0 then
          e.health -= 2
        else
          e.health -= 1
        end
        explode(b.x,b.y,0)
        del(weaponry,b)
        if e.health <= 0 then
          if e.sp == 34 then
            fire(e)
            fire(e)
            fire(e)
          end
          score -= e.points
          del(enemies,e)
          explode(e.x+(e.col/2*8)-1,e.y+(e.row/2*8)-1,1)
        end
      end

    end
  end

  move_player()
end

function draw_level2()
  local cloudcount = 0
  cls()
  rectfill(0,0,128,128,1)
  for st in all(stars) do
    pset(st.x,st.y,st.co)
  end
  for cl in all(clouds) do
    if cl.po == 1 then
      circfill(cl.x,cl.y,cl.r,13)
      circ(cl.x,cl.y,cl.r,5)
      cloudcount += 1
    end
  end
  for cl in all(clouds) do
    if cl.po == 2 then
      circfill(cl.x,cl.y,cl.r,15)
      circ(cl.x,cl.y,cl.r,5)
      cloudcount += 1
    end
  end
  for t in all(tail) do
    circfill(ship.x+t.x,ship.y+t.y,t.r,t.c)
  end
  --draw enemies
  for e in all(enemies) do
    spr(e.sp,e.x,e.y,e.row,e.col,e.reverse,false)
  end

  for p in all(powerups) do
    spr(p.sp,p.x,p.y)
  end

  --draw ship
  spr(ship.sp,ship.x,ship.y)

  --draw bullets
  for b in all(weaponry) do
    spr(b.sp,b.x,b.y)
  end

  --draw enemy bullets
  for ew in all(enemyweaponry) do
    spr(ew.sp,ew.x,ew.y)
  end

  --draw explosions
  for ex in all(explosions) do
    circ(ex.x,ex.y,ex.t/3,8+ex.t%3)
  end


  -- more cloud layers
  for cl in all(clouds) do
    if cl.po == 3 then
      circfill(cl.x,cl.y,cl.r,15)
      circ(cl.x,cl.y,cl.r,5)
      cloudcount += 1
    end
  end
  print((100-(flr(score/6500*100)))..'% to dest.',1,1,6)
end



function update_bossfight2()
  tick += 1
  movesomethings()
  
  for cl in all(clouds) do
    cl.y += cl.s
    if cl.y - cl.r > 128 and cl.redraw then
      cl.x = rnd(128)
      cl.y = rnd(128)-256
      cl.s = flr(rnd(3.5))+ 1
      cl.r = flr(rnd(22))+5
      if cl.s < 2 then
        cl.co = 13
      else
        cl.co = 15
      end
    elseif not cl.redraw and cl.y - cl.r > 128 then
      del(clouds,cl)
      cloudcraft()
    end
  end
  
  --move and delete player bullets
  for b in all(weaponry) do
    b.x += b.dx
    b.y += b.dy
    if b.x < 0 or b.y < 0 or
    b.x >128 or b.y > 128 then
      del(weaponry,b)
    end
    
    for e in all(enemies) do
      if coll(b,e) then
        if ship.dbl > 0 then
          e.health -= 2
        else
          e.health -= 1
        end
        explode(b.x,b.y,0)
        del(weaponry,b)
        if e.health <= 0  and e.sp != 138 then
          del(enemies,e)
          explode(e.x+(e.col/2*8)-1,e.y+(e.row/2*8)-1,1)
        end
      end
    end
  end
  
  
  
  
  for e in all(enemies) do
    if e.sp == 138 then
      if e.health > 0 then
        if e.y < 6 then
          e.y += 0.5
        end
        if tick % 190 == 0 then
          respawn()
        end
      else
        e.y -= 0.5
        if e.y < -35 then
          level = 3
          chapterscreen()
        end
      end
      e.x = e.r*sin(tick/128) + e.m_x
      if tick % 20 == 0  and e.health > 20 and e.y > -2 then
        fire(e)
      elseif tick % 40 == 2 and e.health > 0 then
        fire(e)
      end
      if e.health < 60 then
        e.agro = true
      end
      if e.health <= 0 and e.sp == 138 then
        for i=1,flr(rnd(7)) do
          explode(e.x+rnd(e.box.x2),e.y+rnd(e.box.y2),flr(rnd(2)))
        end
        if tick % 25 == 0 then
          sfx(13)
        end
      end
    elseif e.sp == 35 then
      if e.reverse then
        e.x += 1
        e.y += 2
      else
        e.x -= 1
        e.y += 2
      end
      if e.y > 45 and e.time > 0 and tick % 25 then
        e.time -= 1
        fire(e)
        sfx(1)
      end
    end
    if coll(ship,e) then
      if not shield then
        game_over()
      end
    end
    if e.y >= 150 then
      del(enemies,e)
    end
  end
  
  
  move_player()
  
end

function draw_bossfight2()
  cls()
  pal()
  local cloudcount = 0
  rectfill(0,0,128,128,1)
  for st in all(stars) do
    pset(st.x,st.y,st.co)
  end
  for cl in all(clouds) do
    if cl.po == 1 then
      circfill(cl.x,cl.y,cl.r,13)
      circ(cl.x,cl.y,cl.r,5)
      cloudcount += 1
    end
  end

  for t in all(tail) do
    circfill(ship.x+t.x,ship.y+t.y,t.r,t.c)
  end

  --draw enemy bullets
  for ew in all(enemyweaponry) do
    spr(ew.sp,ew.x,ew.y)
  end

  --draw enemies
  for e in all(enemies) do
    if e.sp == 138 then
      if e.health <= 0 then
        local blink = false
        if tick % 10 == 0 then
          if blink then
            blink = false
          else
            blink = true
          end
        end
        if blink then
          pal(14,5)
          pal(8,4)
          pal(10,2)
        end
      end
      spr(e.sp,e.x,e.y,e.row,e.col,false,false)
      spr(e.sp,e.x+31,e.y,e.row,e.col,true,false)

    else
      spr(e.sp,e.x,e.y,e.row,e.col,e.reverse,false)
    end
  end

  for p in all(powerups) do
    spr(p.sp,p.x,p.y)
  end

  --draw ship
  spr(ship.sp,ship.x,ship.y)

  --draw bullets
  for b in all(weaponry) do
    spr(b.sp,b.x,b.y)
  end

  --draw explosions
  for ex in all(explosions) do
    circ(ex.x,ex.y,ex.t/3,8+ex.t%3)
  end
end


function update_level3()
  tick += 1
  local gravity = 2
  local isonground = false

  groundtest1 = mget(flr((sm.x+1)/8),flr((sm.y+8)/8))
  groundtest1 = mget(flr((sm.x+1)/8),flr((sm.y+8)/8))
  doortest = mget(flr((sm.x+4)/8),flr((sm.y+4)/8))

  if fget(groundtest1,0) or fget(groundtest2,0) then
    isonground = true
  else
    isonground = false
  end

  if sm.y < 223 then
    if not isonground then
      sm.sp = 1
      sm.y += gravity
      if cam.y <= 111 then
        cam.y += gravity
      end
    end
  end
  if not sm.visible then
    convo += 1
  end
  if isonground then
    sm.sp = 18
  end

  if btn(0) then
    sm.reverse = true
    if isonground then
      if tick % 12 == 0 then
        if sm.sp == 18 then
          sm.sp = 2
        else
          sm.sp = 19
        end
      end
    end
    if convo == 0 then
      if sm.x > 0 + sm.speed then
        sm.x -= sm.speed
        if cam.x - sm.speed >= 0 then
          cam.x -= sm.speed
        end
      end
    end
  end
  if btn(1) then
    sm.reverse = false
    if isonground then
      if tick % 12 == 0 then
        if sm.sp == 18 then
          sm.sp = 2
        else
          sm.sp = 18
        end
      end
    end
    if convo == 0 then
      if sm.x < 127 then
        sm.x += sm.speed
        if cam.x + sm.speed <= 7 then
          cam.x += sm.speed
        end
      end
    end
  end
  if btn(2) then
    local u = gravity + 0.25
    sm.fuel -= 0.25
    if convo == 0 then
      if sm.fuel > 0 then
        if cam.y > 0 + u then
          cam.y -= u
          sm.y -= u
        end
      end
    end
  end
  if btnp(5) then
    if fget(doortest,1) then
      sm.visible = false
    end
    if convo > 200 then
      level = 0
      music(0,100)
      title = true
      chapterscreen()
    end
  end
end


function draw_level3()
  cls()
  camera(cam.x,cam.y)
  map(0,0,0,0,17,30)
  if sm.visible then
    spr(sm.sp,sm.x,sm.y,1,1,sm.reverse,false)
  end
  if sm.fuel <= 0 then
    if convo <= 0 then
      print('out of fuel!',cam.x+2,cam.y+2,8)
    end
  end
  if convo > 20 and convo < 200 then
    print('welcome home, dear.',10,145,10)
  end
  if convo >=60 and convo < 200 then
    print('how was your day?',10,155,10)
  end
  if convo >= 90 and convo < 200 then
    print('oh, fine. but the commute\nwas a real beast.',10,165,8)
  end
  if convo > 200 then
    sm.x = 0
    sm.y = 0
    camera(0,0)
    rectfill(0,0,128,128,0)
    print('thank you for guiding\nour hero home!\n\ncoded by sloum\n\n\n\nbased partly on code\nby ztiromoritz\n\nlevel two inspired by\nalpha shooter, coded by\ntashettrash\n\n\n(x) to restart',2,2,6)
  end
end
