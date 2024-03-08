import sys
import pygame

from time import sleep
from button import Button
from settings import Setting
from scoreboard import Scoreboard
from game_stats import GameStats
from ship import Ship
from bullet import Bullet
from alien import Alien

class AlienInvasion:
    """Overall class to manage game assets and behavior"""

    def __init__(self):
        """Initialize the game , and create game resources."""
        pygame.init()
        self.clock = pygame.time.Clock()
        self.settings=Setting()
        """ TO run the game in full screen mode delete the next line and uncomment next three  """
        self.screen=pygame.display.set_mode((self.settings.screen_width,self.settings.screen_height))
        #self.screen = pygame.display.set_mode((0, 0), pygame.FULLSCREEN)
        #self.settings.screen_width = self.screen.get_rect().width
        #self.settings.screen_height = self.screen.get_rect().height
        
        pygame.display.set_caption(self.settings.screen_caption)

        # Create an instance to store game stats
        self.stats = GameStats(self)
        self.sb = Scoreboard(self)
        self.ship=Ship(self)
        self.bullets = pygame.sprite.Group()
        self.aliens = pygame.sprite.Group()
        self._create_fleet()

        # Start alien invasion in inactive state
        self.game_active = False

        # Make a play button
        self.play_button = Button( self, "Play")

    def run_game(self):
        """Starts the main loop for the game"""
        while True:
            self._check_events()
            if self.game_active:
                self.ship.update()   
                self._update_bullets()
                self._update_aliens()
            self._update_screen()
            self.clock.tick(60)

    def _check_events(self):
        #Watch for keyboard and mouse events
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                sys.exit()
            elif event.type == pygame.KEYDOWN:
                self._check_keydown_events(event)
            elif event.type == pygame.KEYUP:
                self._check_keyup_events(event)
            elif event.type == pygame.MOUSEBUTTONDOWN:
                mouse_pos = pygame.mouse.get_pos()
                self._check_play_button(mouse_pos)

    def _check_play_button(self,mouse_pos):
        """ Start a new game when the player hits play."""
        button_clicked = self.play_button.rect.collidepoint(mouse_pos)
        if button_clicked and not self.game_active:

            # Reset game speed
            self.settings.initailize_dynamic_settings()
            # Reset game statistics
            self.stats.reset_stats()
            self.sb.prep_score()
            self.sb.prep_level()
            self.sb.prep_ships()
            self.game_active = True

            #Get rid of any remaining bullets and aliens
            self.bullets.empty()
            self.aliens.empty()

            #Create a new fleet and ceter the ship.
            self._create_fleet()
            self.ship.center_ship()

            # Hide the mouse cursor
            pygame.mouse.set_visible(False)

                
    def _check_keydown_events(self, event):
        """Respond to key presses"""
        if event.key == pygame.K_RIGHT:
            # Move the ship to the right
            self.ship.moving_right = True
        elif event.key == pygame.K_LEFT:
            self.ship.moving_left = True
        elif event.key == pygame.K_SPACE:
            self._fire_bullet()
        elif event.key == pygame.K_q:
            sys.exit()
        

    def _check_keyup_events(self, event):
        """Respond to key releases"""
        if event.key == pygame.K_RIGHT:
            self.ship.moving_right = False
        elif event.key == pygame.K_LEFT:
            self.ship.moving_left = False
        
    def _fire_bullet(self):
        """ Creates a new bullet and adds it to the bullets group"""
        if len(self.bullets) < self.settings.bullets_allowed:
            new_bullet = Bullet(self)
            self.bullets.add(new_bullet)

    def _create_fleet(self):
        """Create a fleet of aliens"""
        # Create an alien and keep adding aliens until there is no room left.
        # Spacing between aliens is one alien width.
        alien = Alien(self)
        alien_width, alien_height =  alien.rect.size
        current_x, current_y = alien_width, (alien_height + 70)

        while current_y < (self.settings.screen_height - 5 * alien_height ):
            while current_x <(self.settings.screen_width - 2 * alien_width):
                self._create_alien(current_x, current_y)
                current_x += 2 * alien_width
            
            current_x = alien_width
            current_y += 2*alien_height

    def _create_alien(self, x_position,y_position):
        """Creates an alien and places it in the row."""
        new_alien = Alien(self)
        new_alien.x = x_position
        new_alien.y = y_position
        new_alien.rect.x = x_position
        new_alien.rect.y = y_position
        self.aliens.add(new_alien)

    def _check_fleet_edges(self):
        """Responds appropriately if any aliens have reached the edge"""
        for alien in self.aliens.sprites():
            if alien.check_edges():
                self._change_fleet_direction()
                break
        
    def _change_fleet_direction(self):
        """ Drop the entire fleet and change the fleet direction"""
        for alien in self.aliens.sprites():
            alien.rect.y += self.settings.fleet_drop_speed
        self.settings.fleet_direction *= -1
    

    def _update_screen(self):
        #Redraw the screen during each pass through the loop
        self.screen.fill(self.settings.bg_color)
        #for bullet in self.bullets.sprites():
        #    bullet.draw_bullet()
        self.bullets.draw(self.screen)
        self.ship.blitme()
        self.aliens.draw(self.screen)
        self.sb.show_score()

        # Draw the play button if the game is inactive
        if not self.game_active:
            self.play_button.draw_button()

        #Make the most recently drawn screen visible
        pygame.display.flip()
    
    def _update_bullets(self):
        """ Update position of bullets and get rid of old bullets."""
        # Update bullet positions
        self.bullets.update()
        # Get rid of bullets that have diappeared
        for bullet in self.bullets.copy():
            if bullet.rect.bottom <= 0:
                self.bullets.remove(bullet)
        self._check_bullet_alien_collisions()        

    def _check_bullet_alien_collisions(self):
        """ Respond to bullet alien collisions"""
        
        # Check for any bullets thta have hit aliens.
        # If so get rid of the bullets and the alien.
        collisions = pygame.sprite.groupcollide(self.bullets, self.aliens, True, True)
        
        if collisions:
            for aliens in collisions.values():    
                self.stats.score += self.settings.alien_points * len(aliens)
            self.sb.prep_score()
            self.sb.check_high_score()  

        if not self.aliens:
                self.bullets.empty()
                self._create_fleet()
                self.settings.increase_speed()

                # Increase level 
                self.stats.level += 1        
                self.sb.prep_level()

    def _update_aliens(self):
        """Check if the fleet is at the edge and then update positions"""
        self._check_fleet_edges()
        self.aliens.update()

        # Look for alien ship collisions
        if pygame.sprite.spritecollideany(self.ship,self.aliens):
            self._ship_hit()
        
        # Check if any alien has reached screen bottom
        self._check_aliens_bottom()

    def _ship_hit(self):
        """Respond to the ship being hit by an aliens"""

        # Decrement ships left and update scoreboard
        self.stats.ships_left -= 1
        self.sb.prep_ships()

        if self.stats.ships_left > 0:

            # Get rid of any remaining bullets and aliens.
            self.bullets.empty()
            self.aliens.empty()

            # Create a new fleet and recenter the ship
            self._create_fleet()
            self.ship.center_ship()

            #Pause
            sleep(1)
        else:
            self.game_active = False
            pygame.mouse.set_visible(True)

    def _check_aliens_bottom(self):
        """ Check if any aliesn have reached the bottom of the screen"""

        for alien in self.aliens.sprites():
            if alien.rect.bottom >= self.settings.screen_height:
                # Treat this same as if the ship was hit
                self._ship_hit()
                break



if __name__ == '__main__':
    # Make a game instance and run the game.
    ai= AlienInvasion()
    ai.run_game()
