class Setting:
    """A class to store all the settings for Alien Invasion"""

    def __init__(self):
        """Initialize the games settings"""
        # Screen settings
        self.screen_width = 1200
        self.screen_height = 800
        self.screen_caption = "Alien Invasion"
        self.bg_color =(230,230,230)

        #Ship settings
        self.ship_limit = 3

        # Bullet settings
        self.bullet_width = 3
        self.bullet_height = 10
        self.bullet_color =(60,60,60)
        self.bullets_allowed = 10

        # How quickly the game speeds up
        self.speedup_scale = 1.3

        # How quickly the alien point values increase
        self.score_scale = 1.5

        # Fleet settings
        self.fleet_drop_speed = 10

        self.initailize_dynamic_settings()

    def initailize_dynamic_settings(self):
        """Initialize settings that change throughout the game."""
        self.ship_speed = 1.5
        self.bullet_speed = 2.5
        self.alien_speed = 2.0

        # Fleet direction of 1 represents 1 and -1 represents left
        self.fleet_direction = 1

        # Scoring settings 
        self.alien_points = 50

    def increase_speed(self):
        """Increase speed settings"""
        self.ship_speed *= self.speedup_scale
        self.bullet_speed *= self.speedup_scale
        self.alien_speed *= self.speedup_scale 
        self. alien_points = int(self.alien_points * self.score_scale)