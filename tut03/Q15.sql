CREATE TABLE player (
    player_name text PRIMARY KEY,
    plays_for text NOT NULL
);


CREATE TABLE team (
    team_name text PRIMARY KEY,
    captain text NOT NULL REFERENCES player (player_name)
);

ALTER TABLE player ADD FOREIGN KEY (plays_for) REFERENCES team (team_name);


CREATE TABLE fan (
    fan_name text PRIMARY KEY
);

CREATE TABLE favourite_team (
    fan_name text REFERENCES fan (fan_name),
    team_name text REFERENCES team (team_name),
    PRIMARY KEY (fan_name, team_name)
);


CREATE TABLE favourite_player (
    fan_name text REFERENCES fan (fan_name),
    player_name text REFERENCES player (player_name),
    PRIMARY KEY (fan_name, player_name)
);

CREATE TABLE team_colours (
    team_name text REFERENCES team (team_name),
    colour text,
    PRIMARY KEY (team_name, colour)
);

CREATE TABLE fav_colours (
    fan_name text REFERENCES fan (fan_name),
    colour text,
    PRIMARY KEY (fan_name, colour)
);
