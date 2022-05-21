const DC_TOKEN = GetConvar('crime_dc_token', 'null');
const DC_APP_ID = GetConvar('crime_dc_app_id', 'null');
const DC_LEADERBOARD_CHANNEL_ID = GetConvar(
  'crime_dc_leaderboard_channel_id',
  'null'
);

if (DC_TOKEN !== 'null' && DC_APP_ID !== 'null') {
  const { Client, Collection, RichEmbed } = require('discord.js');
  const client = new Client();

  /* Main */

  client.on('ready', () => {
    console.log(`Bot logged in as ${client.user.tag}!`);

    RefreshTopByKD();
    RefreshTopByWins();

    setInterval(RefreshTopByKD, 60 * 10000 * 1);
    setInterval(RefreshTopByWins, 60 * 10000 * 1);
  });

  /* Leaderboard */
  const RefreshTopByKD = () => {
    exports.oxmysql.query(
      'SELECT org_label, wins, loses, wins/loses AS kd FROM bitki ORDER BY kd DESC',
      {},
      (result) => {
        if (result) {
          const embed = new RichEmbed()
            .setTitle('Ranking Organizacji - WR')
            .setTimestamp(new Date())
            .setColor(0x9b59b6);

          const players = [];
          for (const index in result) {
            if (index < 10) {
              players.push(
                `${parseInt(index) + 1}. ${result[index].org_label} - W:${
                  result[index].wins
                } L:${result[index].loses} WR:${(
                  result[index].wins / result[index].loses
                ).toFixed(2)}`
              );
            }
          }

          embed.setDescription(players.join('\n'));

          const channel = client.channels.get(DC_LEADERBOARD_CHANNEL_ID);
          if (channel) {
            channel.bulkDelete(5).then(() => {
              channel.send(embed);
            });
          }
        }
      }
    );
  };

  const RefreshTopByWins = () => {
    exports.oxmysql.query(
      'SELECT * FROM bitki ORDER BY wins DESC',
      {},
      (result) => {
        if (result) {
          const embed = new RichEmbed()
            .setTitle('Ranking Organizacji - Winy')
            .setTimestamp(new Date())
            .setColor(0xf1c40f);

          const players = [];
          for (const index in result) {
            if (index < 10) {
              players.push(
                `${parseInt(index) + 1}. ${result[index].org_label} - W:${
                  result[index].wins
                } L:${result[index].loses} WR:${(
                  result[index].wins / result[index].loses
                ).toFixed(2)}`
              );
            }
          }

          embed.setDescription(players.join('\n'));

          const channel = client.channels.get(DC_LEADERBOARD_CHANNEL_ID);
          if (channel) {
            channel.bulkDelete(5).then(() => {
              channel.send(embed);
            });
          }
        }
      }
    );
  };

  client.login(DC_TOKEN).catch((err) => {
    console.log(err);
  });
} else {
  console.log('Invalid convars.');
}
