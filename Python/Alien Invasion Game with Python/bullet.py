import pygame
from pygame.sprite import Sprite

class Bullet(Sprite):
    """A class to manage bulletes fired from the ship"""

    def __init__(self,ai_game):
        """Create a bullet object at the ship's current position."""
        super().__init__()
        self.screen = ai_game.screen
        self.settings = ai_game.settings
        self.color = self.settings.bullet_color

        #Create a bullet at (0,0) and set the correct position
        self.image = pygame.image.load('images/bullet.bmp')
        self.rect = self.image.get_rect()
        self.rect.width = self.settings.bullet_width
        self.rect.height = self.settings.bullet_height
        #self.rect = pygame.Rect(0,0, self.settings.bullet_width,self.settings.bullet_height)
        self.rect.midtop = ai_game.ship.rect.midtop

        # Storte the bullets position as float
        self.y = float(self.rect.y)

    def update(self):
        """ MOve the bullet up the screen"""
        # Update the exact position of the bullet
        self.y -= self.settings.bullet_speed

        # Update the rect position.
        self.rect.y = self.y

    def draw_bullet(self):
        """Draw the bullet tot he screen"""
        pygame.draw.rect(self.screen, self.color, self.rect)

    