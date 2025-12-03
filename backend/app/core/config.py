from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    app_name: str = "Dark Fantasy Compendium API"
    version: str = "1.0.0"
    api_prefix: str = "/api/v1"
    data_dir: str = "app/data"
    
    class Config:
        env_file = ".env"


settings = Settings()

