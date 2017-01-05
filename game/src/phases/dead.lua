local Dead = PlayState:addState('Dead')

function Dead:enteredState()
  love.system.unlockAchievement(IDS.ACH_PLAY_A_GAME)
  love.system.submitScore(IDS.LEAD_SURVIVAL_TIME, self.score * 100)

  PlayState.MUSIC:stop()
  if self.newrecord then
    love.filesystem.write("bestscore", tostring(self.score))
    self.bestscore = self.score
  end

  self:showButtons()
end

function Dead:update(dt)
  -- Update total time.
  self.time = self.time + dt

  self.newrecord_visible = (self.time % 1) < 0.5
  self.player:update(dt)

  self.white_fader.time = self.white_fader.time + dt
  self:updateButtons(dt)
end

function Dead:overlay()
  PlayState.overlay(self)
  if not self.newrecord then
    DrawBestScore(self)
  end
end

function Dead:mousepressed(x, y, button, istouch)
  PlayState.mousepressed(self, x, y, button, istouch)
  if not istouch and not love.mouse.isDown(1) then return end
  if self.ignore_touch then return end
  self:startGame()
end
