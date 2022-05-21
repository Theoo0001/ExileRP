const { RichEmbed } = require('discord.js');

module.exports.execute = (msg, args, exports) => {
    let user = msg.author;

    if (args[0]) {
        const userId = getUserFromMention(args[0]);

        if (userId) {
            user = msg.client.users.get(userId);
        }
    }

    if (user) {
        exports.oxmysql.query('SELECT `name`,`rep`,`discord` FROM `arena` ORDER BY `rep` DESC', {}, (result) => {
            if (result) {
                for (let index = 0; index < result.length; index++) {
                    const player = result[index];

                    if (player && (player.discord == user.id)) {
                        const embed = new RichEmbed({
                            'type': 'rich',
                            'title': `Profil Gracza`,
                            'description': `${player.name}`,
                            'color': 0x07eb97,
                            'fields': [
                                {
                                    'name': `Pozycja w rankingu:`,
                                    'value': `${index + 1}`
                                },
                                {
                                    'name': `Reputacja:`,
                                    'value': `${player.rep}`
                                }
                            ],
                            'thumbnail': {
                                'url': `https://i.pinimg.com/originals/34/7b/d5/347bd5221928832ae99dc3d2f54a440c.png`
                            }
                        })

                        msg.reply(embed);
                        return;
                    }
                }

                msg.reply(`Nie znaleziono konta powiązanego z użytkownikiem: ${user.tag}.`).then((reply) => {
                    reply.delete(5000);
                });
            }
        });
    } else {
        msg.reply(`Nie znaleziono podanego użytkownika.`).then((reply) => {
            reply.delete(5000);
        });
    }
};

function getUserFromMention(mention) {
    if (!mention) return;

    if (mention.startsWith('<@') && mention.endsWith('>')) {
        mention = mention.slice(2, -1);

        if (mention.startsWith('!')) {
            mention = mention.slice(1);
        }

        return mention;
    }
}