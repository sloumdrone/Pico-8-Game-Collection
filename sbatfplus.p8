--super battle arena 
--tank! fighter plus
--by sloum

function _init()
  car = {x=0,y=0,vel=0,angle=0,box={x1=-2,y1=-2,x2=2,y2=2},health=25,meter={counter=0,col=14,c1=14,c2=8}}
  bullets = {}
  enemies = {}
  explosions = {}
  hits = {}
  powerup = {x=64,y=64,maxx=4,box={x1=-6,y1=-6,x2=6,y2=6},collected=false}
  healthpickup = {}
  game = {frict=0.94,tick=0,level=0,over=false,menu=true,kills=0,menu_option=1,menusp={203,219,235,251},info=false,story=false,story_y=129}
  gos = 200
  gosr = false
  music(10,1000)
end

function controller()
  if btn(0) then
    if btn(4) then
      car.angle += 0.005
    else
      car.angle += 0.01
    end
    if car.angle > 1 then
      car.angle = -1
    end
  end
  if btn(1) then
    if btn(4) then
      car.angle -= 0.005
    else
      car.angle -= 0.01
    end
    if car.angle < -1 then
      car.angle = 1
    end
  end
  if btn(2) then
    if car.vel < 3 then
      car.vel += 0.2
    end
  end
  if btn(3) then
    if car.vel > -3 then
      car.vel -= 0.2
    end
  end
  if btnp(5) then
    fire(car)
    sfx(12)
  end
end

function fire(source)
  if source == car then      
    local l = {
      x = source.x+4*cos(source.angle),
      y = source.y+4*sin(source.angle),
      angle = source.angle,
      vel = 4,
      src = 0,
      box = {x1=0,y1=0,x2=0,y2=0}
    }
    add(bullets,l)
  else
    local r = {
      x = source.x+4*sin(source.angle),
      y = source.y+4*cos(source.angle),
      angle = source.angle,
      vel = 4,
      src = 1,
      box = {x1=0,y1=0,x2=0,y2=0}
    }
    add(bullets,r)
  end
end

function make_powerup(src)
  local hp = {
    x = src.x-3,
    y = src.y-3,
    val = 4,
    counter = 0,
    box = {x1=0,y1=0,x2=5,y2=5},
    meter = {col=14,c1=14,c2=8,counter=0}
  }
  add(healthpickup,hp)
end

function flash(object)
  object.meter.counter += 1
  if object.meter.counter > 5 then
    if object.meter.col == object.meter.c1 then
      object.meter.col = object.meter.c2
    else
      object.meter.col = object.meter.c1
    end
    object.meter.counter = 0
  end
end

function explode(obj)
  for i=-1,1,0.1 do
    local p = {
      x=obj.x,
      y=obj.y,
      angle=i,
      vel=1,
      count=0,
      col=10,
      rad=2
    }
    add(explosions,p)
  end
end

function hit(obj)
  add(hits,{x=obj.x,y=obj.y,t=0})
end

function radar_math(num)
  return flr((num + game.level*100)/((game.level*200)/10))
end


function spawn_coordinates()
  if flr(rnd(2)+1) < 2 then
    return flr(rnd(game.level*100*0.98))
  else
    return -flr(rnd(game.level*100*0.98))
  end
end

function spawn_tanks()
  local xx = spawn_coordinates()
  local yy = spawn_coordinates()
  local t = {
    x = xx,
    y = yy,
    angle = 0,
    vel = 0,
    max_vel = rnd(1.75)+0.5,
    col1 = flr(rnd(10)+6),
    col2 = flr(rnd(10)+6),
    box = {x1=-3,y1=-3,x2=3,y2=3},
    health = 5,
    seek_thresh = rnd(220)+70,
    attack_thresh = (rnd(10)-5)+60,
    wand_x = xx,
    wand_y = yy,
    flee_x = 0,
    flee_y = 0,
    mode = 3,
    firetime = flr(rnd(45)+10)
  }
  if t.col1 == t.col2 then
    t.col2 = flr(rnd(10)+6)
  end
  add(enemies,t)
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

function bounce(obj)
  if obj.vel < 1 and obj.vel >= 0 then
    obj.vel = 1
  end
  obj.vel = -(obj.vel+2)
end

function find_distance(one_x, one_y, two_x, two_y)
  return flr(sqrt((((one_x-two_x)/100)^2+((one_y-two_y)/100)^2))*100)
end


function enemy_movement(source)
  --0 = seek
  --1 = flee 
  --2 = attack 
  --3 = wander
  
  local e_start_x = source.x
  local e_start_y = source.y
  local distance = find_distance(source.x,source.y,car.x,car.y)
  
  
  if source.mode == 0 then
    --fake seek mode
    source.angle = atan2(car.y-source.y,car.x-source.x)

    if distance < source.attack_thresh then
      source.mode = 2
    elseif distance >= source.seek_thresh then
      source.mode = 3
    end
    
    if source.vel < source.max_vel then
      source.vel += 0.005
    end
    
    --steer, avoiding walls
    if source.x - 3 + source.vel * sin(source.angle) > -game.level*100 and source.x + 3 + source.vel * sin(source.angle) < game.level*100 then
      source.x += source.vel * sin(source.angle)
    end
    if source.y - 3 + source.vel * cos(source.angle) > -game.level*100 and source.y + 3 + source.vel * cos(source.angle) < game.level*100 then
      source.y += source.vel * cos(source.angle)
    end 
    
  elseif source.mode == 1 then
    --fake flee
    --move in the opposite direction of the player until a certain distance away
    --possibly calculate which wall is furthest from the player and move toward it until a certain distance is made from the player
    local fleemax = 0
    local corners = {{x=game.level*-100+3,y=game.level*-100+3,distance=0},{x=game.level*100-3,y=game.level*100-3,distance=0},{x=game.level*-100+3,y=game.level*100-3,distance=0},{x=game.level*100-3,y=game.level*-100+3,distance=0}} 
    if (source.flee_x == 0 and source.flee_y == 0) then
      for c in all(corners) do
        c.dist = find_distance(c.x,c.y,car.x,car.y)
        fleemax = max(fleemax,c.dist)
      end
      for c in all(corners) do
        if c.dist == fleemax then
          source.flee_x = c.x
          source.flee_y = c.y
          break
        end
      end 
    end  
    source.angle = atan2(source.y-source.flee_y,source.x-source.flee_x)
    if source.x - 3 + source.vel * sin(source.angle) > -game.level*100 and source.x + 3 + source.vel * sin(source.angle) < game.level*100 then
      source.x += source.vel * sin(source.angle)
    end
    if source.y - 3 + source.vel * cos(source.angle) > -game.level*100 and source.y + 3 + source.vel * cos(source.angle) < game.level*100 then
      source.y += source.vel * cos(source.angle)
    end 
    if distance > source.seek_thresh then
      source.mode = 3
      source.flee_x = 0
      source.flee_y = 0
    end
  elseif source.mode == 2 then
    --fake fight
    --stand ground and shoot at player, if hit, flee
    source.angle = atan2(car.y-source.y,car.x-source.x)
    
    if game.tick % source.firetime == 0 then
      fire(source)
      sfx(8)
      source.firetime = flr(rnd(45)+10)
    end
    if distance >= source.seek_thresh then
      source.mode = 3
    elseif distance >= source.attack_thresh then
      source.mode = 0
    end
  else
    --mode 3 = fake wander
    --[[randomly pick a destination, if source gets to the point
    then pick another random destination to drive to,
    if at any time the player is within the distance to player is 
    less than the thresh distance switch to mode 0 (seek)
    ]]
    if distance < source.attack_thresh then
      source.mode = 2
    elseif distance < source.seek_thresh then
      source.mode = 0
    end
    
    if find_distance(flr(source.x),flr(source.y),flr(source.wand_x),flr(source.wand_y)) <= 4 then
      source.wand_x = spawn_coordinates()
      source.wand_y = spawn_coordinates()
    else
      source.angle = atan2(source.wand_y - source.y,source.wand_x - source.x)
      if source.vel < source.max_vel then
        source.vel += 0.005
      end
      if source.x - 3 + source.vel * sin(source.angle) > -game.level*100 and source.x + 3 + source.vel * sin(source.angle) < game.level*100 then
        source.x += source.vel * sin(source.angle)
      end
      if source.y - 3 + source.vel * cos(source.angle) > -game.level*100 and source.y + 3 + source.vel * cos(source.angle) < game.level*100 then
        source.y += source.vel * cos(source.angle)
      end 
    end
  end
end




function _update()
  if game.menu then
    if btnp(1) or btnp(2) then
      game.menu_option += 1
      if game.menu_option > 4 then
        game.menu_option = 1
      end
    end
    if btnp(0) or btnp(3) then
      game.menu_option -= 1
      if game.menu_option < 1 then
        game.menu_option = 4
      end
    end
    if btnp(4) or btnp(5) then
      if game.menu_option == 1 then
        game.menu = false
        music(-1,1000)
      elseif game.menu_option == 2 then
        game.menu = false
        game.level = 3
        music(-1,1000)
      elseif game.menu_option == 3 then
        if game.info then
          game.info = false
        else
          game.info = true
          game.story = false
        end
      elseif game.menu_option == 4 then
        if game.story then
          game.story = false
          game.story_y = 129
        else
          game.story = true
          game.info = false
        end
      end
    end 
    if game.story then
      if game.story_y > 1 then
        game.story_y -= 2
      end
    end
  else
    if not game.over then
      controller()
      game.tick += 1
      
      if car.health <= 0 then
        explode(car)
        sfx(14)
        game.over = true
        music(20,1000)
      end
      
      if #enemies <= 0 then
        if game.menu_option == 2 then
          for i=1,25 do
            spawn_tanks()
          end
        else
          game.level += 1
          sfx(15)
          game.tick = 0
          for i=1,flr(game.level * 2.25) do
            spawn_tanks()
          end
        end
      end
      
      --player movement
      if car.x - 3 + car.vel * cos(car.angle) > -game.level*100 and car.x + 3 + car.vel * cos(car.angle) < game.level*100 then
        car.x += car.vel * cos(car.angle)
      end
      if car.y - 3 + car.vel * sin(car.angle) > -game.level*100 and car.y + 3 + car.vel * sin(car.angle) < game.level*100 then
        car.y += car.vel * sin(car.angle)
      end
      
      if car.vel != 0 then
        car.vel *= game.frict
        if car.vel < 0.1 and car.vel > -0.1 then
          car.vel = 0
        end
      end

      if car.health < 11 then
        flash(car)
      else
        car.meter.col = car.meter.c1
      end

      --dealing with powerups
      for hp in all(healthpickup) do
        flash(hp)
        hp.counter += 1
        if hp.counter >= 180 then
          del(healthpickup,hp)
        end
        if coll(car,hp) then
          healthpickup.collected = true
          car.health += hp.val
          if car.health > 25 then
            car.health = 25
          end
          del(healthpickup,hp)
          sfx(16)
        end
      end
      

      
      
      --enemy movement
      for e in all(enemies) do
        local e_start_x = e.x
        local e_start_y = e.y
      
        enemy_movement(e)
        if e.vel < 0 then
          e.vel += game.frict
        end
        if coll(car,e) then
          bounce(car)
          bounce(e)
        end
        for e2 in all(enemies) do
          if e2 != e then
            if coll(e2,e) then
              e.x = e_start_x
              e.y = e_start_y
            end
          end
        end
      end
      
      --projectile movement
      for b in all(bullets) do
        if b.src == 0 then
          b.x += b.vel * cos(b.angle)
          b.y += b.vel * sin(b.angle)
        else
          b.x += b.vel * sin(b.angle)
          b.y += b.vel * cos(b.angle)
        end
        if b.x > car.x + 120 or b.x < car.x - 120 or b.y > car.y + 120 or b.y < car.y - 120 then
          del(bullets,b)
        elseif b.x > game.level*100 or b.x < game.level * -100 or b.y > game.level * 100 or b.y < game.level * -100 then
          del(bullets,b)
        end
        if coll(b,car) then
          hit(car)
          car.health -= 1
          sfx(9)
          del(bullets,b)
        end
        if b.src == 0 then
          for e in all(enemies) do
            if coll(b,e) then
              hit(e)
              del(bullets,b)
              sfx(10)
              e.health -= 1
              if flr(rnd(50)) == 1 then
                e.mode = 1
              end
              if e.health <= 0 then
                explode(e)
                if flr(rnd(3)) == 1 then
                  make_powerup(e)
                end
                del(enemies,e)
                game.kills += 1
                sfx(14)
                if game.menu_option == 2 then
                  spawn_tanks()
                end
              end
            end
          end
        end
      end
      
      for hi in all(hits) do
        hi.t += 1
        if hi.t == 10 then
          del(hits,hi)
        end
      end
      
      for ex in all(explosions) do
        ex.x += ex.vel * sin(ex.angle)
        ex.y += ex.vel * cos(ex.angle)
        ex.count += 1
        if ex.count < 4 then
          ex.col = 7
        elseif ex.count < 8 then
          ex.col = 10
        elseif ex.count < 12 then
          ex.col = 9
        elseif ex.count < 16 then
          ex.col = 8
        elseif ex.count < 20 then
          ex.col = 2
        elseif ex.count < 24 then
          ex.col = 1
        else
          del(explosions,ex)
        end
      end
    else
      if gos == -200 then
        gosr = true
      elseif gos == 200 then
        gosr = false
      end
      if gosr then
        gos += 1
      else
        gos -= 1
      end
      for exs in all(explosions) do
        exs.x += exs.vel * sin(exs.angle)
        exs.y += exs.vel * cos(exs.angle)
        exs.count += 1
        if exs.count < 4 then
          exs.col = 7
        elseif exs.count < 8 then
          exs.col = 10
        elseif exs.count < 12 then
          exs.col = 9
        elseif exs.count < 16 then
          exs.col = 8
        elseif exs.count < 20 then
          exs.col = 2
        elseif exs.count < 24 then
          exs.col = 1
        else
          del(explosions,exs)
        end
      end
      if btnp(0) and btnp(1) then
        music(-1,300)
        _init()
      end
    end
  end
end


function _draw()
  cls()
  if game.menu then
    camera()
    for i=0,100 do
      pset(flr(rnd(128)),flr(rnd(128)),6)
    end
    if game.info then
      spr(201,35,10,2,2)
      spr(game.menusp[game.menu_option],51,10,3,1)
      spr(206,75,10,2,2)
      print("x - fire weapon\nz - hold for precise turn/aim\n\148 - accelerate\n\131 - reverse\n\139/\145 - turn/rotate\n\n\n   collect \135 icons to heal\n\nmodes:\narcade - scaled levels\nblitz  - hordes of enemies\n\n            made by sloum, 2017",2,34,11)
    elseif game.story then
      spr(201,35,10,2,2)
      spr(game.menusp[game.menu_option],51,10,3,1)
      spr(206,75,10,2,2)
      print('  in a world fraught with\nviolence, corruption, and\npower-hungry warlords, it is\nup to you to escape the central\ncompound and bring valued intel\nto the resistance.\n\n\n\n  armed with a stealth tank,\ngrit, and your will to survive;\nyou must make it out to safety\nand take out as many of the\nenemy as you can to end the\nreign of evil once and for all.',game.story_y,32,11)
      spr(41,game.story_y+45,72,3,1)
    else 
      spr(128,32,24,8,7)
      spr(201,35,92,2,2)
      spr(game.menusp[game.menu_option],51,92,3,1)
      spr(206,75,92,2,2)
      print('\139               \145',25,99,6)      
    end
  else
    if not game.over then
      
      local start_w = game.level * 100
      local start_h = game.level * 100
      
      --draw arena
      for i=-start_w,start_w,50 do
        line(i,-start_h,i,start_h,1)
        line(-start_w,i,start_w,i,1)
      end
      rect(-start_w-1,-start_h-1,start_w+1,start_h+1,2)
      rect(-start_w-2,-start_h-2,start_w+2,start_h+2,2)
      rect(-start_w-3,-start_h-3,start_w+3,start_h+3,2)
      rect(-start_w-4,-start_h-4,start_w+4,start_h+4,2)
      camera()

          
      
      --set camera
      camera(car.x-64,car.y-64)

      --draw powerups
      for hp in all(healthpickup) do
        print('\135',hp.x,hp.y,hp.meter.col)
      end  

      --draw player
      circfill(car.x,car.y,2,11)
      line(car.x,car.y, car.x+4*cos(car.angle),car.y+4*sin(car.angle),10)
      
      --draw enemies
      for e in all(enemies) do
        circfill(e.x,e.y,3,e.col1)  
        line(e.x,e.y, e.x+6*sin(e.angle),e.y+6*cos(e.angle),e.col2)
      end
      
      for b in all(bullets) do
        pset(b.x,b.y,flr(rnd(10))+6)
      end
      
      for hi in all(hits) do
        circ(hi.x,hi.y,hi.t/3,8+hi.t%3)
      end
      
      for ex in all(explosions) do
        circfill(ex.x,ex.y,ex.rad,ex.col)
      end

      --meters
      rect(car.x+36,car.y-60,car.x+48,car.y-52,15)
      rectfill(car.x+37,car.y-59,car.x+47,car.y-53,1)
      print('\135',car.x+39,car.y-58,car.meter.col) --135 = heart
      rect(car.x+36,car.y-52,car.x+48,car.y-48,15)
      rectfill(car.x+37,car.y-51,car.x+37+flr(car.health/2.5),car.y-49,car.meter.col)
      rect(car.x+36,car.y-48,car.x+60,car.y-40,15)
      rectfill(car.x+37,car.y-47,car.x+59,car.y-41,1)
      if game.menu_option == 2 then
        print('blitz',car.x+38,car.y-46,14)
      else
        print('lvl '..game.level,car.x+38,car.y-46,14)
      end
      --radar
      rect(car.x+48,car.y-60,car.x+60,car.y-48,15)
      rectfill(car.x+49,car.y-59,car.x+59,car.y-49,1)
      for en in all(enemies) do
        pset(car.x+49+radar_math(en.x),car.y-59+radar_math(en.y),8)
      end
      pset(car.x+49+radar_math(car.x),car.y-59+radar_math(car.y),11)
    else
      camera()
      camera(car.x-64,car.y-64)
      for i=0,50 do
        pset(flr(car.x-64+rnd(128)),flr(car.y-64+rnd(128)),6)
      end
      sspr(8,0,64,56,car.x-gos,car.y-gos,gos*2,gos*2,false,false)
      if game.menu_option == 2 then
        print('   blitz kills: '..game.kills,car.x-40,car.y-8,flr(rnd(7)+7))
      else
        print('tanks destroyed: '..game.kills,car.x-40,car.y-8,flr(rnd(7)+7))
      end
      print('press \139 + \145 to restart',car.x-46,car.y,flr(rnd(7)+7))
      for ex in all(explosions) do
        circfill(ex.x,ex.y,ex.rad,ex.col)
      end
    end
  end
end
