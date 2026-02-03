{
  port ? 8000,
  vhost ? "raspi.fish-mahi.ts.net",
}: {...}: {
  services.forgejo = {
    enable = true;
    lfs.enable = true;
    database.type = "postgres";
    settings = {
      DEFAULT.APP_NAME = "Forgejo";
      server = {
        ROOT_URL = "https://${vhost}";
        HTTP_PORT = port;
        DOMAIN = vhost;
      };
      service = {
        DISABLE_REGISTRATION = true;
        DEFAULT_KEEP_EMAIL_PRIVATE = true;
        LANDING_PAGE = "explore";
      };
      session.COOKIE_SECURE = true;
      repository.ENABLE_PUSH_CREATE_USER = true;
    };
  };
}
