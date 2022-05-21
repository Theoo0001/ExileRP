setTimeout(() => {
  const Discord = require('discord.js');
  const mysql = require('mysql');
  const fetch = require('node-fetch');
  const hastebin = require('hastebin-gen');
  const { exec, spawn } = require('child_process');
  const client = new Discord.Client();

  let players = {};

  let con = mysql.createConnection({
    host: 'localhost',
    database: 'exilewloff',
    user: 'root',
    password: 'msxLqFyaWBTwubU8RPwF',
  });

  con.connect(function (err) {
    if (err) throw err;
    console.log('\u001b[32m exile_discord: Connected to database! \u001b[37m');
  });

  client.on('ready', async () => {
    console.log(`Logged in as ${client.user.tag}!`);
    client.user.setActivity('ExileRP WL OFF', { type: 'WATCHING' });
    const myGuild = client.guilds.get('909797606027309086');
    const promptChannel = client.channels.get('819711388803923985');
    const cconsole = client.channels.get('909797606027309086');
    //const logChannel = client.channels.get('655677918843764736');
    //const restartChannel = client.channels.get('648174751218663433');
    //const allLogsChannel = client.channels.get('676925244958834737');

    function getUser(id) {
      if (myGuild == undefined) {
        return undefined;
      }
      if (myGuild.members.find((user) => user.id == id)) {
        return myGuild.members.find((user) => user.id == id);
      }
      return undefined;
    }

    function getUserRole(user, roleName) {
      if (user.roles.find((role) => role.name === roleName)) {
        return user.roles.find((role) => role.name === roleName);
      }
      return undefined;
    }

    function getPlayerIdentifier(name) {
      for (let i = 0; i < GetNumPlayerIdentifiers(source); i++) {
        if (GetPlayerIdentifier(source, i).substr(0, name.length) == name) {
          return GetPlayerIdentifier(source, i);
        }
      }
      return undefined;
    }

    function getSourceIdentifier(source, name) {
      for (let i = 0; i < GetNumPlayerIdentifiers(source); i++) {
        if (GetPlayerIdentifier(source, i).substr(0, name.length) == name) {
          return GetPlayerIdentifier(source, i);
        }
      }
      return undefined;
    }

    function reconnect(con) {
      promptChannel.send('```\n Tworzenie ponownie połączenia...```');

      con = mysql.createConnection({
        host: 'localhost',
        database: 'exilewloff',
        user: 'root',
        password: 'msxLqFyaWBTwubU8RPwF',
      });
      con.connect(function (err) {
        if (err) throw err;
        console.log('\u001b[32m exile_discord: ALL OK \u001b[37m');
      });
    }

    function log(source, text) {
      if (source == undefined || source == -1 || source == 0) {
        return logChannel.send(`console => ${text}`);
      } else if (players[source] == undefined) {
        let discord = getSourceIdentifier(source, 'discord');
        if (!discord) {
          players[source] = {
            source: source,
            steam: getSourceIdentifier(source, 'steam'),
            ip: getSourceIdentifier(source, 'ip'),
          };
          return logChannel.send(
            `<@${players[source].steam}> | ${players[source].source} => ${text}`
          );
        }
        discord = discord.substr(8);
        players[source] = {
          source: source,
          steam: getSourceIdentifier(source, 'steam'),
          ip: getSourceIdentifier(source, 'ip'),
          discord: discord,
        };
        return logChannel.send(
          `<@${players[source].discord}> | ${players[source].source} => ${text}`
        );
      }
      return logChannel.send(
        `<@${players[source].discord}> | ${players[source].source} => ${text}`
      );
    }

    function sendEmbed(channel, message, author) {
      let exampleEmbed = new Discord.MessageEmbed()
        .setColor('#0099ff')
        .setTitle('ExileRP WL OFF')
        .setURL('http://exilerp.eu/')
        .setThumbnail(
          'https://media.discordapp.net/attachments/651095238424789022/722168567725949038/logo.png?width=560&height=560'
        )
        .setTimestamp();

      if (!author || author == undefined) {
        exampleEmbed.setAuthor(
          client.user.username,
          client.user.avatarURL(),
          ''
        );
      } else {
        exampleEmbed.setAuthor(author.username, author.avatarURL(), '');
      }

      if (message.charAt(0) == '+') message = message.substr(1);
      let channelName = channel.name;

      if (message.match(/<thumbnail>([^']+)<thumbnail>/)) {
        exampleEmbed.setThumbnail(
          message.match(/<thumbnail>([^']+)<thumbnail>/)[1]
        );
        message = message.replace(
          '<thumbnail>' +
            message.match(/<thumbnail>([^']+)<thumbnail>/)[1] +
            '<thumbnail>',
          ''
        );
      }

      if (message.match(/<url>([^']+)<url>/)) {
        exampleEmbed.setURL(message.match(/<url>([^']+)<url>/)[1]);
        message = message.replace(
          '<url>' + message.match(/<url>([^']+)<url>/)[1] + '<url>',
          ''
        );
      }

      if (message.match(/<footer>([^']+)<footer>/)) {
        exampleEmbed.setFooter(message.match(/<footer>([^']+)<footer>/)[1]);
        message = message.replace(
          '<footer>' + message.match(/<footer>([^']+)<footer>/)[1] + '<footer>',
          ''
        );
      }

      if (message.match(/<color>([^']+)<color>/)) {
        exampleEmbed.setColor(message.match(/<color>([^']+)<color>/)[1]);
        message = message.replace(
          '<color>' + message.match(/<color>([^']+)<color>/)[1] + '<color>',
          ''
        );
      }

      if (message.match(/<description>([^']+)<description>/)) {
        exampleEmbed.setDescription(
          message.match(/<description>([^']+)<description>/)[1]
        );
        message = message.replace(
          '<description>' +
            message.match(/<description>([^']+)<description>/)[1] +
            '<description>',
          ''
        );
      }

      if (message.match(/<title>([^']+)<title>/)) {
        exampleEmbed.setTitle(message.match(/<title>([^']+)<title>/)[1]);
        message = message.replace(
          '<title>' + message.match(/<title>([^']+)<title>/)[1] + '<title>',
          ''
        );
      }

      if (message.match(/<channel>([^']+)<channel>/)) {
        channelName = message.match(/<channel>([^']+)<channel>/)[1];
        message = message.replace(
          '<channel>' +
            message.match(/<channel>([^']+)<channel>/)[1] +
            '<channel>',
          ''
        );
      }

      let fieldLabels = message.split('+');
      let fieldValue = '';
      for (let i = 0; i < fieldLabels.length; i++) {
        if (fieldLabels[i].match(/<v>([^']+)<v>/)) {
          fieldValue = fieldLabels[i].match(/<v>([^']+)<v>/)[1];
          fieldLabels[i] = fieldLabels[i].replace(
            '<v>' + fieldValue + '<v>',
            ''
          );
        }
        if (fieldValue == '' || fieldValue == ' ') fieldValue = '_';
        exampleEmbed.addField(fieldLabels[i], '-' + fieldValue);
      }

      let foundChannel = client.channels.find(
        (channel) => channel.name === channelName
      );
      if (foundChannel) {
        foundChannel.send(exampleEmbed);
      } else {
        channel.send(exampleEmbed);
      }
    }

    function replyDatabaseResult(query, columns, max) {
      if (max != -1 && max != undefined) {
        max = ' LIMIT ' + max;
      } else if (max == -1) {
        max = '';
      } else if (max == undefined) {
        max = ' LIMIT ' + 10;
      }

      con.query(query + max, function (err, result) {
        if (err)
          throw promptChannel.send(
            '```diff\n-#' +
              err.errno +
              ' ' +
              err.name +
              ' ' +
              err.message +
              '```'
          );
        //return reconnect(con);
        //} else {
        let columnshelp = '**';
        if (columns) {
          for (let i = 0; i < columns.length; i++) {
            columnshelp = columnshelp + columns[i] + ' | ';
          }
          columnshelp = columnshelp + '**';
          promptChannel.send(columnshelp);
        }
        let reply = '```';
        for (let i = 0; i < result.length; i++) {
          if (reply.length >= 1024) {
            reply = reply.substr(0, 1024);
            reply = reply + '```';
            promptChannel.send(reply);
            reply = '```';
          }
          if (columns) {
            for (let j = 0; j < columns.length; j++) {
              reply = reply + result[i][columns[j]] + ' | ';
            }
          } else {
            reply = reply + result[i] + ' | ';
          }
          reply = reply + '\n';
        }
        reply = reply + '```';
        promptChannel.send(reply);
        //}
      });
    }

    async function switchMysqlCommand(msg, message) {
      let identifier = msg.split(' ')[1];
      let max = msg.split(' ')[2];
      if (max == undefined || max == '' || max == ' ') {
        max = msg.split(' ')[1];
        if (max == undefined || max == '' || max == ' ' || isNaN(max)) {
          max = 10;
        }
      }
      switch (msg.split(' ')[0]) {
        case 'unixdate':
          let dateu = new Date(parseInt(identifier) * 1000);
          message.reply(
            `UNIX: ${identifier} to ${
              dateu.toISOString().slice(0, 10) +
              ' ' +
              dateu.toISOString().slice(-13, -5)
            }`
          );
          break;
        case 'alllicenses':
          replyDatabaseResult(`SELECT * FROM licenses`, ['type', 'label'], max);
          break;
        case 'items':
          replyDatabaseResult(
            `SELECT * FROM items`,
            ['name', 'label', 'limit', 'rare', 'canremove'],
            max
          );
          break;
        case 'jobs':
          replyDatabaseResult(
            `SELECT * FROM job_grades`,
            ['job_name', 'grade', 'label', 'salary'],
            max
          );
          break;
        case 'checkwl':
          replyDatabaseResult(
            `SELECT * FROM whitelist WHERE identifier = '${identifier}'`,
            ['identifier', 'license', 'discord', 'ticket', 'back'],
            max
          );
          break;
        case 'checkdc':
          replyDatabaseResult(
            `SELECT * FROM whitelist WHERE discord = 'discord:${identifier}'`,
            ['identifier', 'license', 'discord', 'ticket', 'back'],
            max
          );
          break;
        case 'checklicense':
          replyDatabaseResult(
            `SELECT * FROM whitelist WHERE license = 'license:${identifier}'`,
            ['identifier', 'license', 'discord', 'ticket', 'back'],
            max
          );
          break;
        case 'checkban':
          replyDatabaseResult(
            `SELECT * FROM exile_bans WHERE license = 'license:${identifier}'`,
            [
              'license',
              'identifier',
              'name',
              'discord',
              'added',
              'expired',
              'reason',
              'bannedby',
              'isBanned',
            ],
            max
          );
          break;
        case 'bank':
          replyDatabaseResult(
            `SELECT identifier, JSON_EXTRACT(accounts, '$.bank') AS bank FROM users ORDER BY CAST(bank AS INT) DESC`,
            ['identifier', 'bank'],
            max
          );
          break;
        case 'money':
          replyDatabaseResult(
            `SELECT identifier, JSON_EXTRACT(accounts, '$.money') AS money FROM users ORDER BY CAST(money AS INT) DESC`,
            ['identifier', 'money'],
            max
          );
          break;
        case 'dirty':
          replyDatabaseResult(
            `SELECT identifier, JSON_EXTRACT(accounts, '$.black_money') AS dirty FROM users ORDER BY CAST(dirty AS INT) DESC`,
            ['identifier', 'dirty'],
            max
          );
          break;
        case 'name':
          replyDatabaseResult(
            `SELECT * FROM users WHERE name = '${identifier}'`,
            [
              'identifier',
              'digit',
              'name',
              'job',
              'job_grade',
              'hiddenjob',
              'hiddenjob_grade',
              'job_level',
              'accounts',
              'loadout',
              'inventory',
              'firstname',
              'lastname',
              'phone_number',
            ],
            10
          );
          break;
        case 'user':
          replyDatabaseResult(
            `SELECT * FROM users WHERE identifier = '${identifier}'`,
            [
              'identifier',
              'digit',
              'name',
              'job',
              'job_grade',
              'hiddenjob',
              'hiddenjob_grade',
              'job_level',
              'accounts',
              'loadout',
              'inventory',
              'firstname',
              'lastname',
              'phone_number',
            ],
            max
          );
          break;
        case 'userall':
          userAll(msg);
          break;
        case 'character':
          replyDatabaseResult(
            `SELECT * FROM users WHERE firstname = '${identifier}' AND lastname = '${max}'`,
            [
              'identifier',
              'digit',
              'name',
              'job',
              'job_grade',
              'hiddenjob',
              'hiddenjob_grade',
              'job_level',
              'accounts',
              'loadout',
              'inventory',
              'firstname',
              'lastname',
              'phone_number',
            ],
            50
          );
          break;
        case 'characters':
          replyDatabaseResult(
            `SELECT * FROM characters WHERE identifier = '${identifier}'`,
            ['identifier', 'digit', 'firstname', 'lastname'],
            10
          );
          break;
        case 'addonaccount':
          replyDatabaseResult(
            `SELECT * FROM addon_account_data WHERE account_name = '${identifier}'`,
            ['account_name', 'money', 'account_money']
          );
          break;
        case 'datastore':
          replyDatabaseResult(
            `SELECT * FROM datastore_data WHERE name = '${identifier}'`,
            ['name', 'data'],
            255
          );
          break;
        case 'addonitems':
          replyDatabaseResult(
            `SELECT * FROM addon_inventory_items WHERE inventory_name = '${identifier}' ORDER BY addon_inventory_items.count DESC`,
            ['inventory_name', 'name', 'count'],
            255
          );
          break;
        case 'properties':
          replyDatabaseResult(
            `SELECT * FROM owned_properties WHERE owner = '${identifier}'`,
            ['owner', 'digit', 'name', 'price', 'rented'],
            50
          );
          break;
        case 'licenses':
          replyDatabaseResult(
            `SELECT * FROM user_licenses WHERE owner = '${identifier}'`,
            ['owner', 'digit', 'type'],
            50
          );
          break;
        case 'vehicles':
          replyDatabaseResult(
            `SELECT owner, digit, plate, state, JSON_EXTRACT(vehicle, '$.model') AS model FROM owned_vehicles WHERE owner = '${identifier}'`,
            ['owner', 'digit', 'plate', 'state', 'model'],
            50
          );
          break;
        case 'topaddonaccount':
          replyDatabaseResult(
            `SELECT * FROM addon_account_data ORDER BY addon_account_data.account_money DESC`,
            ['owner', 'account_name', 'account_money'],
            max
          );
          break;
        case 'topaddonaccountdirty':
          replyDatabaseResult(
            `SELECT * FROM addon_account_data ORDER BY addon_account_data.money DESC`,
            ['owner', 'account_name', 'money'],
            max
          );
          break;
        case 'phonecontacts':
          replyDatabaseResult(
            `SELECT * FROM phone_users_contacts WHERE identifier = '${identifier}'`,
            ['number', 'display'],
            max
          );
          break;
        case 'phonemessages':
          replyDatabaseResult(
            `SELECT * FROM phone_messages WHERE transmitter = '${identifier}'`,
            ['receiver', 'message', 'time', 'isRead'],
            max
          );
          break;
        case 'phonecalls':
          replyDatabaseResult(
            `SELECT * FROM phone_calls WHERE owner = '${identifier}'`,
            ['num', 'time', 'accepts'],
            max
          );
          break;
        case 'phoneappchat':
          replyDatabaseResult(
            `SELECT * FROM phone_app_chat WHERE channel = '${identifier}'`,
            ['message', 'time'],
            max
          );
          break;
        case 'lastphonemessages':
          replyDatabaseResult(
            `SELECT * FROM phone_messages ORDER BY phone_messages.time DESC`,
            ['receiver', 'message', 'time', 'isRead'],
            max
          );
          break;
        case 'lastphonecalls':
          replyDatabaseResult(
            `SELECT * FROM phone_calls ORDER BY phone_calls.time DESC`,
            ['num', 'time', 'accepts'],
            max
          );
          break;
        case 'lastphoneappchat':
          replyDatabaseResult(
            `SELECT * FROM phone_app_chat ORDER BY phone_app_chat.time DESC`,
            ['message', 'time'],
            max
          );
          break;

        default:
          ExecuteCommand(msg);
      }
    }

    function userAll(msg) {
      let availablecommands = ['user', 'licenses', 'properties', 'vehicles'];
      for (let i = 0; i < availablecommands.length; i++) {
        switchMysqlCommand(availablecommands[i] + msg.substring(7));
      }
    }

    client.on('message', (msg) => {
      if (msg.author.bot) {
        return;
      }
      if (msg.channel === promptChannel) {
        switchMysqlCommand(msg.content, msg);
      } else if (msg.channel === cconsole) {
        let command = msg.content.split(' ')[0];
        msg.content = msg.content.split(' ').slice(1).join('');
        switch (command) {
          case '!embed':
            sendEmbed(cconsole, msg.content, msg.author);
            break;
          default:
            msg.reply('Brak takiej komendy');
        }
      }
    });
    RegisterCommand(
      'restart_prompt',
      function () {
        return reconnect(con);
      },
      true
    );
    RegisterCommand(
      'kick',
      function (source, args, rawcommand) {
        if (!args[0] || !args[1]) {
          return promptChannel.send(`:x: kick [id] [powód]`);
        }
        DropPlayer(args[0], args[1]);
      },
      true
    );

    RegisterCommand(
      'wiadomosc',
      function (source, args, rawcommand) {
        if (!args[0] || !args[1]) {
          return promptChannel.send(`:x: wiadomosc [id] [msg]`);
        }
        emitNet('chat:addMessage', args[0], {
          args: ['ADMIN: ', args[1], 200, 50, 50, 'fas fa-bible'],
        });
      },
      true
    );

    RegisterCommand(
      'komendy',
      function (source, args, rawcommand) {
        let allcmd = GetRegisteredCommands();
        for (var i = 0; i < allcmd.length; i += 20) {
          promptChannel.send(
            ` \`\`\`${allcmd[i].name} | ${allcmd[i + 1].name} | ${
              allcmd[i + 2].name
            } | ${allcmd[i + 3].name} | ${allcmd[i + 4].name} | ${
              allcmd[i + 5].name
            } | ${allcmd[i + 6].name} | ${allcmd[i + 7].name} | ${
              allcmd[i + 8].name
            } | ${allcmd[i + 9].name} | ${allcmd[i + 10].name} | ${
              allcmd[i + 11].name
            } | ${allcmd[i + 12].name} | ${allcmd[i + 13].name} | ${
              allcmd[i + 14].name
            } | ${allcmd[i + 15].name} | ${allcmd[i + 16].name} | ${
              allcmd[i + 17].name
            } | ${allcmd[i + 18].name} | ${allcmd[i + 19].name} | \`\`\` `
          );
        }
      },
      true
    );
  });

  client.login('OTIzOTEyMDA5NDc5NzY2MDU3.YcW6HA.KgvXEGii8eJdeY50TbhWBOfQUwA');
}, 5000);
