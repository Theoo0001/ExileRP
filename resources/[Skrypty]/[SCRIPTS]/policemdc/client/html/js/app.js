(function (t) {
  function e(e) {
    for (
      var i, o, c = e[0], s = e[1], l = e[2], u = 0, d = [];
      u < c.length;
      u++
    )
      (o = c[u]), a[o] && d.push(a[o][0]), (a[o] = 0);
    for (i in s) Object.prototype.hasOwnProperty.call(s, i) && (t[i] = s[i]);
    m && m(e);
    while (d.length) d.shift()();
    return r.push.apply(r, l || []), n();
  }

  function n() {
    for (var t, e = 0; e < r.length; e++) {
      for (var n = r[e], i = !0, o = 1; o < n.length; o++) {
        var c = n[o];
        0 !== a[c] && (i = !1);
      }
      i && (r.splice(e--, 1), (t = s((s.s = n[0]))));
    }
    return t;
  }
  var i = {},
    o = {
      app: 0,
    },
    a = {
      app: 0,
    },
    r = [];

  function c(t) {
    return s.p + 'js/' + ({}[t] || t) + '.js';
  }

  function s(e) {
    if (i[e]) return i[e].exports;
    var n = (i[e] = {
      i: e,
      l: !1,
      exports: {},
    });
    return t[e].call(n.exports, n, n.exports, s), (n.l = !0), n.exports;
  }
  (s.e = function (t) {
    var e = [],
      n = {
        'chunk-234381ab': 1,
        'chunk-237795f2': 1,
        'chunk-5b01a659': 1,
        'chunk-810c293a': 1,
      };
    o[t]
      ? e.push(o[t])
      : 0 !== o[t] &&
        n[t] &&
        e.push(
          (o[t] = new Promise(function (e, n) {
            for (
              var i = 'css/' + ({}[t] || t) + '.css',
                a = s.p + i,
                r = document.getElementsByTagName('link'),
                c = 0;
              c < r.length;
              c++
            ) {
              var l = r[c],
                u = l.getAttribute('data-href') || l.getAttribute('href');
              if ('stylesheet' === l.rel && (u === i || u === a)) return e();
            }
            var d = document.getElementsByTagName('style');
            for (c = 0; c < d.length; c++) {
              (l = d[c]), (u = l.getAttribute('data-href'));
              if (u === i || u === a) return e();
            }
            var m = document.createElement('link');
            (m.rel = 'stylesheet'),
              (m.type = 'text/css'),
              (m.onload = e),
              (m.onerror = function (e) {
                var i = (e && e.target && e.target.src) || a,
                  r = new Error(
                    'Loading CSS chunk ' + t + ' failed.\n(' + i + ')'
                  );
                (r.code = 'CSS_CHUNK_LOAD_FAILED'),
                  (r.request = i),
                  delete o[t],
                  m.parentNode.removeChild(m),
                  n(r);
              }),
              (m.href = a);
            var h = document.getElementsByTagName('head')[0];
            h.appendChild(m);
          }).then(function () {
            o[t] = 0;
          }))
        );
    var i = a[t];
    if (0 !== i)
      if (i) e.push(i[2]);
      else {
        var r = new Promise(function (e, n) {
          i = a[t] = [e, n];
        });
        e.push((i[2] = r));
        var l,
          u = document.createElement('script');
        (u.charset = 'utf-8'),
          (u.timeout = 120),
          s.nc && u.setAttribute('nonce', s.nc),
          (u.src = c(t)),
          (l = function (e) {
            (u.onerror = u.onload = null), clearTimeout(d);
            var n = a[t];
            if (0 !== n) {
              if (n) {
                var i = e && ('load' === e.type ? 'missing' : e.type),
                  o = e && e.target && e.target.src,
                  r = new Error(
                    'Loading chunk ' + t + ' failed.\n(' + i + ': ' + o + ')'
                  );
                (r.type = i), (r.request = o), n[1](r);
              }
              a[t] = void 0;
            }
          });
        var d = setTimeout(function () {
          l({
            type: 'timeout',
            target: u,
          });
        }, 12e4);
        (u.onerror = u.onload = l), document.head.appendChild(u);
      }
    return Promise.all(e);
  }),
    (s.m = t),
    (s.c = i),
    (s.d = function (t, e, n) {
      s.o(t, e) ||
        Object.defineProperty(t, e, {
          enumerable: !0,
          get: n,
        });
    }),
    (s.r = function (t) {
      'undefined' !== typeof Symbol &&
        Symbol.toStringTag &&
        Object.defineProperty(t, Symbol.toStringTag, {
          value: 'Module',
        }),
        Object.defineProperty(t, '__esModule', {
          value: !0,
        });
    }),
    (s.t = function (t, e) {
      if ((1 & e && (t = s(t)), 8 & e)) return t;
      if (4 & e && 'object' === typeof t && t && t.__esModule) return t;
      var n = Object.create(null);
      if (
        (s.r(n),
        Object.defineProperty(n, 'default', {
          enumerable: !0,
          value: t,
        }),
        2 & e && 'string' != typeof t)
      )
        for (var i in t)
          s.d(
            n,
            i,
            function (e) {
              return t[e];
            }.bind(null, i)
          );
      return n;
    }),
    (s.n = function (t) {
      var e =
        t && t.__esModule
          ? function () {
              return t['default'];
            }
          : function () {
              return t;
            };
      return s.d(e, 'a', e), e;
    }),
    (s.o = function (t, e) {
      return Object.prototype.hasOwnProperty.call(t, e);
    }),
    (s.p = ''),
    (s.oe = function (t) {
      throw (console.error(t), t);
    });
  var l = (window['webpackJsonp'] = window['webpackJsonp'] || []),
    u = l.push.bind(l);
  (l.push = e), (l = l.slice());
  for (var d = 0; d < l.length; d++) e(l[d]);
  var m = u;
  r.push([0, 'chunk-vendors']), n();
})({
  0: function (t, e, n) {
    t.exports = n('56d7');
  },
  '0121': function (t, e, n) {
    t.exports = n.p + 'img/citizen-image-placeholder.png';
  },
  '034f': function (t, e, n) {
    'use strict';
    var i = n('64a9'),
      o = n.n(i);
    o.a;
  },
  '066d': function (t, e, n) {
    t.exports = n.p + 'img/lspdLogo.png';
  },
  '139d': function (t, e, n) {},
  1428: function (t, e, n) {
    'use strict';
    var i = n('139d'),
      o = n.n(i);
    o.a;
  },
  1771: function (t, e, n) {
    var i = {
      './citizen-image-placeholder.png': '0121',
      './dojLogo.png': '8c64',
      './example-image.jpg': '248e',
      './lspdLogo.png': '066d',
      './lssdLogo.png': 'bff7',
      './saspLogo.png': '4f84',
    };

    function o(t) {
      var e = a(t);
      return n(e);
    }

    function a(t) {
      var e = i[t];
      if (!(e + 1)) {
        var n = new Error("Cannot find module '" + t + "'");
        throw ((n.code = 'MODULE_NOT_FOUND'), n);
      }
      return e;
    }
    (o.keys = function () {
      return Object.keys(i);
    }),
      (o.resolve = a),
      (t.exports = o),
      (o.id = '1771');
  },
  '237c': function (t, e, n) {
    'use strict';
    var i = n('a4f0'),
      o = n.n(i);
    o.a;
  },
  '248e': function (t, e, n) {
    t.exports = n.p + 'img/example-image.jpg';
  },
  '4eaa': function (t, e, n) {
    'use strict';

    function i(t) {
      for (var e in t) if (t.hasOwnProperty(e)) return !1;
      return !0;
    }

    function o(t, e) {
      return ((t - (new Date().getTime() - e)) / 1e3).toFixed(2);
    }
    n.d(e, 'b', function () {
      return i;
    }),
      n.d(e, 'a', function () {
        return o;
      });
  },
  '4f84': function (t, e, n) {
    t.exports = n.p + 'img/saspLogo.png';
  },
  '56d7': function (t, e, n) {
    'use strict';
    n.r(e);
    n('cadf'), n('551c'), n('f751'), n('097d');
    var i = n('2b0e'),
      o = function () {
        var t = this,
          e = t.$createElement,
          n = t._self._c || e;
        return t.isVisible
          ? n(
              'div',
              {
                attrs: {
                  id: 'app',
                },
              },
              [n('router-view')],
              1
            )
          : t._e();
      },
      a = [],
      r =
        (n('916a'),
        {
          name: 'app',
          mounted: function () {
            this.$policeApi.loadConfig();
          },
          computed: {
            isVisible: function () {
              return this.$store.state.isPoliceMdcVisible;
            },
          },
        }),
      c = r,
      s = (n('034f'), n('2877')),
      l = Object(s['a'])(c, o, a, !1, null, null, null),
      u = l.exports,
      d = n('8c4f'),
      m = (n('7f7f'), n('96cf'), n('3b8d')),
      h = n('2f62'),
      f = n('4eaa'),
      v = !1,
      p = {
        name: 'Adam DSADASS',
        birthdate: '1990/02/22',
        gender: 'M',
        profileImage: '',
        isWanted: !1,
        isDangerous: !0,
        isDrugDealer: !0,
        isWeaponDealer: !0,
        isInCriminalGroup: !0,
        notes: [
          {
            addedBy: 'John Snow',
            date: '19/08/2019',
            text: 'Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki ',
          },
          {
            addedBy: 'John Snow',
            date: '21/05/2019',
            text: 'DLUZSZA NOTATKA DLUZSZA NOTATKA DLUZSZA NOTATKA DLUZSZA NOTATKA DLUZSZA NOTATKA DLUZSZA NOTATKA DLUZSZA NOTATKA DLUZSZA NOTATKA DLUZSZA NOTATKA DLUZSZA NOTATKA DLUZSZA NOTATKA DLUZSZA NOTATKA DLUZSZA NOTATKA DLUZSZA NOTATKA DLUZSZA NOTATKA DLUZSZA NOTATKA DLUZSZA NOTATKA ',
          },
          {
            addedBy: 'UHDSSADHU DSSHSDAHSADHJ',
            date: '21/08/2018',
            text: 'Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki ',
          },
          {
            addedBy: 'GAASDAD ASDADDA',
            date: '20/08/2019',
            text: 'Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki ',
          },
          {
            addedBy: 'DSA WEQ',
            date: '17/08/2019',
            text: 'Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki Treść notatki ',
          },
        ],
        //businesses: [{
        //name: "Jakis biznes"
        // }, {
        //  name: "Kolejny biznes"
        //}],
        houses: [
          {
            name: 'Nazwa mieszkania',
          },
          {
            name: 'Kolejne mieszkania',
          },
          {
            name: 'Trzecie mieszkanie',
          },
          {
            name: 'Nazwa mieszkania',
          },
          {
            name: 'Kolejne mieszkania',
          },
          {
            name: 'Trzecie mieszkanie',
          },
          {
            name: 'Nazwa mieszkania',
          },
          {
            name: 'Kolejne mieszkania',
          },
          {
            name: 'Trzecie mieszkanie',
          },
        ],
        convictions: [
          {
            date: '20/02/2019',
            crimes:
              'Coś tam x3 | Napad na FP x1 | Dodatkowe x3 | Dodatkowe x3 | Dodatkowe x3 | Dodatkowe x3 | Dodatkowe x3 | Dodatkowe x3 | Dodatkowe x3 | Dodatkowe x3 | Dodatkowe x3',
            length: 80,
            fee: 1000.25,
            note: 'Dodatkowa notatka do przestępstwa jakaś nawet trochę dłuższa czy coś 21321 231 231 2312 3132 2 1qk2eldsajldsajhjdjkdsahksdkajsdabjksdbjsdbj',
            addedBy: 'John Snow',
          },
          {
            date: '20/02/2019',
            crimes: 'Coś tam x3 | Napad na FP x1 | Dodatkowe x3',
            length: 80,
            fee: 1000.25,
            note: 'Dodatkowa notatka do przestępstwa',
            addedBy: 'John Snow',
          },
          {
            date: '20/02/2019',
            crimes: 'Coś tam x3 | Napad na FP x1 | Dodatkowe x3',
            length: 80,
            fee: 1000.25,
            note: 'Dodatkowa notatka do przestępstwa',
            addedBy: 'John Snow',
          },
          {
            date: '20/02/2019',
            crimes: 'Coś tam x3 | Napad na FP x1 | Dodatkowe x3',
            length: 80,
            fee: 1000.25,
            note: '',
            addedBy: 'John Snow',
          },
        ],
        lspdTags: ['Poszukiwany'],
      },
      g = {
        name: 'John Snow',
        jobName: 'lspd',
      },
      b = [
        {
          id: 1,
          name: 'Poszukiwany',
          description: 'Obywatel jest aktualnie poszukiwany',
          type: 'CITIZEN',
        },
        {
          id: 2,
          name: 'Niebezpieczny',
          description: 'Obywatel jest niebezpieczny',
          type: 'CITIZEN',
        },
      ];

    function C() {
      return {
        convictionsAuthors: '',
        convictionNote: '',
        selectedConvictions: [],
        customConviction: {
          name: '',
          fee: 0,
          length: 0,
          times: 1,
        },
      };
    }
    i['default'].use(h['a']);
    var w = {
        isPoliceMdcVisible: v,
        userData: null,
        searchCitizenName: '',
        searchCitizenState: {
          inProgress: !1,
          notFoundError: !1,
        },
        searchedCitizen: {},
        searchedCitizenCandidates: null,
        tags: [],
        convictions: [],
        newConviction: {
          id: '',
          citizenName: '',
          crimes: '',
          note: '',
          length: 0,
          fee: 0,
          addedBy: '',
        },
        searchVehiclePlateText: '',
        searchVehicleState: {
          inProgress: !1,
          notFoundError: !1,
        },
        searchedVehicle: {},
        citizensWarrantsList: [],
        vehiclesWarrantsList: [],
        departments: {},
        convictionPageData: C(),
      },
      y = new h['a'].Store({
        state: w,
        mutations: {
          SET_CONVICTIONS: function (t, e) {
            t.convictions = e;
          },
          setConvictions: function (t, e) {
            t.convictions = e;
          },
          SET_DEPARTMENTS: function (t, e) {
            t.departments = e;
          },
          SET_USER_DATA: function (t, e) {
            t.userData = e;
          },
          setSearchedCitizenData: function (t, e) {
            (t.searchedCitizenCandidates = null),
              (t.searchedCitizen = e),
              (t.convictionPageData = C()),
              (t.searchCitizenState.inProgress = !1),
              (t.searchCitizenState.notFoundError =
                null == e || jQuery.isEmptyObject(e));
          },
          setSearchedCitizenCandidates: function (t, e) {
            (t.searchedCitizen = {}),
              (t.searchedCitizenCandidates = e),
              (t.searchCitizenState.inProgress = !1);
          },
          clearSearchedCitizenData: function (t) {
            (t.searchedCitizenCandidates = null), (t.searchedCitizen = null);
          },
          setSearchedVehicle: function (t, e) {
            (t.searchedVehicle = e),
              (t.searchVehicleState.inProgress = !1),
              (t.searchVehicleState.notFoundError =
                null == e || jQuery.isEmptyObject(e));
          },
          clearSearchedVehicle: function (t) {
            t.searchedVehicle = null;
          },
          setMdcTags: function (t, e) {
            t.tags = e;
          },
          setPoliceTabletVisible: function (t, e) {
            t.isPoliceMdcVisible = e;
          },
          setCitizensWarrants: function (t, e) {
            t.citizensWarrantsList = e;
          },
          setVehicleWarrants: function (t, e) {
            t.vehiclesWarrantsList = e;
          },
          SET_SEARCH_CITIZEN_NAME: function (t, e) {
            null != e && e.length > 0 && (t.searchCitizenName = e);
          },
          SET_SEARCH_VEHICLE_PLATE_TEXT: function (t, e) {
            null != e && e.length > 0 && (t.searchVehiclePlateText = e);
          },
          SET_CITIZENS_WARRANTS_LIST: function (t, e) {
            console.log(
              'SET_CITIZENS_WARRANS_LIST DATA = ' + JSON.stringify(e, null, 4)
            ),
              (t.citizensWarrantsList = e);
          },
          SET_VEHICLES_WARRANTS_LIST: function (t, e) {
            console.log(
              'SET_CITIZENS_WARRANS_LIST DATA = ' + JSON.stringify(e, null, 4)
            ),
              (t.vehiclesWarrantsList = e);
          },
          setUserData: function (t, e) {
            console.log('SET_USER_DATA DATA = ' + e),
              (t.userData = e),
              H.push('/');
          },
        },
        actions: {
          loadConfig: (function () {
            var t = Object(m['a'])(
              regeneratorRuntime.mark(function t(e, n) {
                var i;
                return regeneratorRuntime.wrap(function (t) {
                  while (1)
                    switch ((t.prev = t.next)) {
                      case 0:
                        (i = e.commit),
                          i('SET_CONVICTIONS', n.convictions),
                          i('SET_DEPARTMENTS', n.departmensVariations),
                          console.log(
                            'LOADED CONFIG IS = '.concat(JSON.stringify(n))
                          );
                      case 4:
                      case 'end':
                        return t.stop();
                    }
                }, t);
              })
            );

            function e(e, n) {
              return t.apply(this, arguments);
            }
            return e;
          })(),
          addNewCitizenNote: function (t, e) {
            var n = t.state;
            null != n.searchedCitizen &&
              (n.searchedCitizen.notes.unshift(e),
              console.log('Added new citizen note in UI'));
          },
          saveCitizenConviction: function (t, e) {
            var n = t.state,
              i = e.citizenId,
              o = e.citizenName,
              a = e.userName,
              r = e.crimes,
              c = e.note,
              s = e.totalConvictionFee,
              l = e.totalConvictionLength;
            (n.newConviction.id = i),
              (n.newConviction.citizenName = o),
              (n.newConviction.addedBy = a),
              (n.newConviction.crimes = r),
              (n.newConviction.note = c),
              (n.newConviction.fee = s),
              (n.newConviction.length = l);
          },
          addNewCitizenConviction: function (t) {
            var e = t.state;
            if (
              null != e.newConviction &&
              null != e.searchedCitizen &&
              e.searchedCitizen.name == e.newConviction.citizenName
            ) {
              var n = new Date(Date.now());
              e.searchedCitizen.convictions.unshift({
                date:
                  n.toLocaleDateString('en-GB') +
                  ' ' +
                  n.toLocaleTimeString('en-GB'),
                id: e.newConviction.id,
                crimes: e.newConviction.crimes,
                length: e.newConviction.length,
                fee: e.newConviction.fee,
                addedBy: e.newConviction.addedBy,
                note: e.newConviction.note,
              }),
                (e.convictionPageData = C()),
                console.log(
                  'Convictions = '.concat(e.searchedCitizen.convictions)
                );
            }
          },
          addNewVehicleNote: function (t, e) {
            var n = t.state;
            null != n.searchedVehicle &&
              (n.searchedVehicle.notes.unshift(e),
              console.log('Added new vehicle note on UI'));
          },
        },
        getters: {
          citizenNotesSortedByDate: function (t) {
            return null == t.searchedCitizen || null == t.searchedCitizen.notes
              ? null
              : t.searchedCitizen.notes;
          },
          citizenConvictionsSortedByDate: function (t) {
            return null == t.searchedCitizen ||
              null == t.searchedCitizen.convictions
              ? null
              : t.searchedCitizen.convictions;
          },
          getSearchedCitizen: function (t) {
            return (
              v && (t.searchedCitizen = p),
              Object(f['b'])(t.searchedCitizen) ? null : t.searchedCitizen
            );
          },
          getSearchedCitizenCandidates: function (t) {
            return t.searchedCitizenCandidates;
          },
          getSearchedVehicle: function (t) {
            return Object(f['b'])(t.searchedVehicle) ? null : t.searchedVehicle;
          },
          getCitizenTags: function (t) {
            return v
              ? b
              : t.tags.filter(function (t) {
                  return 'CITIZEN' == t.type;
                });
          },
          getVehicleTags: function (t) {
            return t.tags.filter(function (t) {
              return 'VEHICLE' == t.type;
            });
          },
          vehicleNotesSortedByDate: function (t) {
            return null == t.searchedVehicle || null == t.searchedVehicle.notes
              ? null
              : t.searchedVehicle.notes;
          },
          getUser: function (t) {
            return v && (t.userData = g), t.userData;
          },
          getUserName: function (t) {
            return t.userData.name;
          },
          getUserDepartmentGrade: function (t) {
            return t.userData.departmentGrade;
          },
          getDepartmentName: function (t) {
            return t.userData && null != t.departments[t.userData.jobName]
              ? t.departments[t.userData.jobName].displayName
              : 'San Andreas State Police';
          },
          getDepartmentLogo: function (t) {
            return t.userData && null != t.departments[t.userData.jobName]
              ? n('1771')('./'.concat(t.departments[t.userData.jobName].logo))
              : n('066d');
          },
          getNewConviction: function (t) {
            return t.newConviction;
          },
          getCitizensWarrantsList: function (t) {
            return Object(f['b'])(t.citizensWarrantsList)
              ? null
              : t.citizensWarrantsList;
          },
          getVehiclesWarrantsList: function (t) {
            return Object(f['b'])(t.vehiclesWarrantsList)
              ? null
              : t.vehiclesWarrantsList;
          },
        },
      }),
      T = function () {
        var t = this,
          e = t.$createElement,
          n = t._self._c || e;
        return n(
          'div',
          {
            attrs: {
              id: 'police-mdc',
            },
          },
          [
            n(
              'b-container',
              {
                staticClass: 'police-mdc-container',
                attrs: {
                  fluid: '',
                },
              },
              [
                n(
                  'b-row',
                  [
                    n('police-mdc-header', {
                      attrs: {
                        user: t.getUser,
                        isLoggedIn: t.isLoggedIn,
                      },
                    }),
                    n(
                      'b-col',
                      {
                        attrs: {
                          cols: '12',
                        },
                      },
                      [
                        n(
                          'b-row',
                          {
                            staticClass: 'h-100',
                          },
                          [
                            n(
                              'b-col',
                              {
                                staticClass: 'police-mdc-navbar',
                                attrs: {
                                  cols: '12',
                                },
                              },
                              [
                                n(
                                  'b-row',
                                  {
                                    staticClass: 'h-100',
                                  },
                                  [
                                    n('b-col', {
                                      attrs: {
                                        cols: '3',
                                      },
                                    }),
                                    n(
                                      'b-col',
                                      {
                                        attrs: {
                                          cols: '9',
                                        },
                                      },
                                      [
                                        n(
                                          'b-row',
                                          {
                                            staticClass:
                                              'align-content-center h-100',
                                          },
                                          [
                                            n(
                                              'b-col',
                                              {
                                                attrs: {
                                                  cols: '2',
                                                },
                                              },
                                              [
                                                n(
                                                  'div',
                                                  {
                                                    staticClass: 'dropdown',
                                                  },
                                                  [
                                                    n(
                                                      'b-button',
                                                      {
                                                        staticClass:
                                                          'drop-button',
                                                        on: {
                                                          click: t.minimize,
                                                        },
                                                      },
                                                      [t._v('ZMINIMALIZUJ')]
                                                    ),
                                                  ],
                                                  1
                                                ),
                                              ]
                                            ),
                                            n(
                                              'b-col',
                                              {
                                                attrs: {
                                                  cols: '2',
                                                },
                                              },
                                              [
                                                t.isLoggedIn
                                                  ? n(
                                                      'div',
                                                      {
                                                        staticClass: 'dropdown',
                                                      },
                                                      [
                                                        n(
                                                          'b-button',
                                                          {
                                                            staticClass:
                                                              'drop-button',
                                                            attrs: {
                                                              to: {
                                                                path: '/',
                                                              },
                                                            },
                                                          },
                                                          [t._v('HOME')]
                                                        ),
                                                      ],
                                                      1
                                                    )
                                                  : t._e(),
                                              ]
                                            ),
                                            n(
                                              'b-col',
                                              {
                                                attrs: {
                                                  cols: '2',
                                                },
                                              },
                                              [
                                                t.isLoggedIn
                                                  ? n(
                                                      'div',
                                                      {
                                                        staticClass: 'dropdown',
                                                      },
                                                      [
                                                        n(
                                                          'b-button',
                                                          {
                                                            staticClass:
                                                              'drop-button',
                                                          },
                                                          [t._v('WYSZUKAJ')]
                                                        ),
                                                        n(
                                                          'div',
                                                          {
                                                            staticClass:
                                                              'dropdown-content',
                                                          },
                                                          [
                                                            n(
                                                              'b-link',
                                                              {
                                                                attrs: {
                                                                  to: {
                                                                    name: 'searchCitizensPage',
                                                                  },
                                                                },
                                                              },
                                                              [
                                                                t._v(
                                                                  'Obywatela'
                                                                ),
                                                              ]
                                                            ),
                                                            n(
                                                              'b-link',
                                                              {
                                                                attrs: {
                                                                  to: {
                                                                    name: 'searchVehiclesPage',
                                                                  },
                                                                },
                                                              },
                                                              [t._v('Pojazd')]
                                                            ),
                                                          ],
                                                          1
                                                        ),
                                                      ],
                                                      1
                                                    )
                                                  : t._e(),
                                              ]
                                            ),
                                            n(
                                              'b-col',
                                              {
                                                attrs: {
                                                  cols: '2',
                                                },
                                              },
                                              [
                                                t.isLoggedIn
                                                  ? n(
                                                      'div',
                                                      {
                                                        staticClass: 'dropdown',
                                                      },
                                                      [
                                                        n(
                                                          'b-button',
                                                          {
                                                            staticClass:
                                                              'drop-button',
                                                          },
                                                          [t._v('LIST GOŃCZY')]
                                                        ),
                                                        n(
                                                          'div',
                                                          {
                                                            staticClass:
                                                              'dropdown-content',
                                                          },
                                                          [
                                                            n(
                                                              'b-link',
                                                              {
                                                                attrs: {
                                                                  to: {
                                                                    name: 'citizenWarrantsPage',
                                                                  },
                                                                },
                                                              },
                                                              [t._v('Obywatel')]
                                                            ),
                                                            n(
                                                              'b-link',
                                                              {
                                                                attrs: {
                                                                  to: {
                                                                    name: 'vehicleWarrantsPage',
                                                                  },
                                                                },
                                                              },
                                                              [t._v('Pojazd')]
                                                            ),
                                                          ],
                                                          1
                                                        ),
                                                      ],
                                                      1
                                                    )
                                                  : t._e(),
                                              ]
                                            ),
                                            n(
                                              'b-col',
                                              {
                                                attrs: {
                                                  cols: '2',
                                                },
                                              },
                                              [
                                                n(
                                                  'div',
                                                  {
                                                    staticClass: 'dropdown',
                                                  },
                                                  [
                                                    n(
                                                      'b-button',
                                                      {
                                                        staticClass:
                                                          'drop-button',
                                                        on: {
                                                          click: t.quit,
                                                        },
                                                      },
                                                      [t._v('WYJDŹ')]
                                                    ),
                                                  ],
                                                  1
                                                ),
                                              ]
                                            ),
                                          ],
                                          1
                                        ),
                                      ],
                                      1
                                    ),
                                  ],
                                  1
                                ),
                              ],
                              1
                            ),
                          ],
                          1
                        ),
                      ],
                      1
                    ),
                  ],
                  1
                ),
                n(
                  'b-row',
                  {
                    staticClass: 'police-mdc-page-content',
                  },
                  [
                    n(
                      'b-container',
                      {
                        staticClass: 'pt-4',
                        attrs: {
                          fluid: '',
                        },
                      },
                      [
                        n(
                          'transition',
                          {
                            attrs: {
                              name: 'fade',
                              mode: 'out-in',
                            },
                          },
                          [n('keep-alive', [n('router-view')], 1)],
                          1
                        ),
                      ],
                      1
                    ),
                  ],
                  1
                ),
                n(
                  'b-row',
                  {
                    staticClass: 'police-container-footer',
                  },
                  [n('police-container-footer')],
                  1
                ),
              ],
              1
            ),
          ],
          1
        );
      },
      k = [],
      D = function () {
        var t = this,
          e = t.$createElement,
          n = t._self._c || e;
        return n(
          'b-col',
          {
            staticClass: 'footer',
            attrs: {
              cols: '12',
            },
          },
          [
            n(
              'b-row',
              {
                staticClass: 'd-flex',
              },
              [
                n('b-col', {
                  staticClass: 'line',
                  attrs: {
                    cols: '12',
                  },
                }),
              ],
              1
            ),
            n(
              'b-row',
              [
                n(
                  'b-col',
                  {
                    staticClass: 'ml-auto',
                    attrs: {
                      cols: 'auto',
                    },
                  },
                  [n('span', [t._v('\n    To Protect & To Serve\n      ')])]
                ),
              ],
              1
            ),
          ],
          1
        );
      },
      z = [],
      S = (n('237c'), {}),
      N = Object(s['a'])(S, D, z, !1, null, '3b029c4e', null),
      A = N.exports,
      _ = function () {
        var t = this,
          e = t.$createElement,
          n = t._self._c || e;
        return n(
          'b-col',
          {
            attrs: {
              cols: '12',
            },
          },
          [
            n(
              'b-row',
              {
                staticClass: 'mx-auto',
              },
              [
                n(
                  'b-col',
                  {
                    staticClass: 'logo-container',
                    attrs: {
                      cols: '3',
                    },
                  },
                  [
                    n('img', {
                      staticClass: 'police-logo img-fluid mx-auto d-block',
                      attrs: {
                        src: t.getDepartmentLogo,
                      },
                    }),
                  ]
                ),
                n(
                  'b-col',
                  {
                    staticClass: 'text-center my-auto',
                    attrs: {
                      cols: '4',
                    },
                  },
                  [n('span', [t._v(t._s(t.getHeaderText))])]
                ),
                n(
                  'b-col',
                  {
                    attrs: {
                      cols: '5',
                    },
                  },
                  [
                    n(
                      'h2',
                      {
                        staticClass: 'state-text',
                      },
                      [
                        n('span', [
                          t._v(
                            '\n          ' +
                              t._s(t.getDepartmentName) +
                              '\n        '
                          ),
                        ]),
                      ]
                    ),
                  ]
                ),
              ],
              1
            ),
          ],
          1
        );
      },
      x = [],
      P = {
        name: 'policeMdcHeader',
        props: {
          user: {
            type: Object,
          },
          isLoggedIn: {
            type: Boolean,
          },
        },
        computed: {
          getHeaderText: function () {
            return this.isLoggedIn
              ? 'Witaj, '.concat(this.user.name)
              : 'Zaloguj się aby kontynuować';
          },
          getDepartmentName: function () {
            return this.$store.getters.getDepartmentName;
          },
          getDepartmentLogo: function () {
            return this.$store.getters.getDepartmentLogo;
          },
        },
      },
      L = P,
      j = (n('f8d3'), Object(s['a'])(L, _, x, !1, null, '3ad6392d', null)),
      O = j.exports,
      E = {
        name: 'policeMdc',
        components: {
          PoliceContainerFooter: A,
          PoliceMdcHeader: O,
        },
        props: {
          policeData: {
            type: Object,
            default: function () {
              return {
                employee: {
                  name: 'Imię Nazwisko',
                  rank: 'Jakaś jego ranga',
                },
              };
            },
          },
        },
        data: function () {
          return {
            sideMenuItems: [
              {
                icon: 'Home',
                page: 'STRONA GŁÓWNA',
                action: 'someAction',
              },
              {
                icon: 'Home',
                page: 'STRONA GŁÓWNA2',
                action: 'someAction',
              },
            ],
            currentMenuName: 'STRONA GŁÓWNA',
          };
        },
        methods: {
          minimize: function () {
            this.$policeApi.closePoliceMdc();
          },
          quit: function () {
            console.log('Destroying tablet'),
              this.$store.commit('SET_USER_DATA', null),
              this.$router.push('/login'),
              this.$policeApi.closePoliceMdc();
          },
          moveSearchCitizens: function () {
            this.$router.push({
              name: 'searchCitizensPage',
            });
          },
        },
        computed: {
          getUser: function () {
            return this.$store.state.userData;
          },
          isLoggedIn: function () {
            return null != this.getUser;
          },
        },
      },
      I = E,
      W = (n('1428'), Object(s['a'])(I, T, k, !1, null, '308d977f', null)),
      V = W.exports,
      Z = function () {
        var t = this,
          e = t.$createElement,
          n = t._self._c || e;
        return n(
          'b-row',
          {
            staticClass: 'new-conviction-container mt-2',
          },
          [
            null == t.getCitizen
              ? n(
                  'b-col',
                  [
                    n(
                      'b-alert',
                      {
                        attrs: {
                          show: '',
                          variant: 'danger',
                        },
                      },
                      [
                        t._v(
                          '\n        Aby dodać nowy wyrok musisz najpierw wyszukać obywatela.\n      '
                        ),
                      ]
                    ),
                  ],
                  1
                )
              : n(
                  'b-col',
                  [
                    n(
                      'b-row',
                      [
                        n(
                          'b-col',
                          {
                            attrs: {
                              cols: '6',
                            },
                          },
                          [
                            n(
                              'b-row',
                              [
                                n('b-form-input', {
                                  attrs: {
                                    placeholder: 'Wyszukaj wyrok...',
                                  },
                                  model: {
                                    value: t.convictionName,
                                    callback: function (e) {
                                      t.convictionName = e;
                                    },
                                    expression: 'convictionName',
                                  },
                                }),
                              ],
                              1
                            ),
                            n(
                              'b-row',
                              [
                                n(
                                  'b-col',
                                  {
                                    staticClass:
                                      'convictions-container overflow-auto mt-1',
                                  },
                                  t._l(t.filteredConvictions, function (e, i) {
                                    return n(
                                      'b-row',
                                      {
                                        key: i,
                                      },
                                      [
                                        n(
                                          'b-col',
                                          {
                                            staticClass: 'conviction-category',
                                            attrs: {
                                              cols: '12',
                                            },
                                          },
                                          [
                                            n(
                                              'p',
                                              {
                                                staticClass: 'police-text',
                                              },
                                              [
                                                t._v(
                                                  '\n                    ' +
                                                    t._s(e.categoryName) +
                                                    '\n                  '
                                                ),
                                              ]
                                            ),
                                            n(
                                              'b-row',
                                              t._l(e.items, function (i, o) {
                                                return n(
                                                  'b-col',
                                                  {
                                                    key: o,
                                                    staticClass:
                                                      'conviction-item-container pt-1',
                                                    attrs: {
                                                      cols: '4',
                                                    },
                                                  },
                                                  [
                                                    i.showName
                                                      ? n(
                                                          'b-button',
                                                          {
                                                            staticClass:
                                                              'text-center conviction-item',
                                                            style: {
                                                              'background-color':
                                                                e.color,
                                                            },
                                                            attrs: {
                                                              'text-variant':
                                                                'white',
                                                            },
                                                            on: {
                                                              click: function (
                                                                e
                                                              ) {
                                                                return t.addConviction(
                                                                  i
                                                                );
                                                              },
                                                            },
                                                          },
                                                          [
                                                            t._v(
                                                              '\n\t\t\t\t\t\t\t' +
                                                                t._s(i.name)
                                                            ),
                                                            n('br'),
                                                            n('br'),
                                                            t._v(
                                                              '\t\t\t\t\t\t\n\t\t\t\t\t\t\t' +
                                                                t._s(
                                                                  i.description
                                                                )
                                                            ),
                                                            n('br'),
                                                            t._v(
                                                              '\n\t\t\t\t\t\t\t(' +
                                                                t._s(i.fee) +
                                                                '$) (' +
                                                                t._s(i.length) +
                                                                'M)\n\t\t\t\t\t\t'
                                                            ),
                                                          ]
                                                        )
                                                      : n(
                                                          'b-button',
                                                          {
                                                            staticClass:
                                                              'text-center conviction-item',
                                                            style: {
                                                              'background-color':
                                                                e.color,
                                                            },
                                                            attrs: {
                                                              'text-variant':
                                                                'white',
                                                            },
                                                            on: {
                                                              click: function (
                                                                e
                                                              ) {
                                                                return t.addConviction(
                                                                  i
                                                                );
                                                              },
                                                            },
                                                          },
                                                          [
                                                            t._v(
                                                              '\t\t\t\t\n\t\t\t\t\t\t\t' +
                                                                t._s(
                                                                  i.description
                                                                )
                                                            ),
                                                            n('br'),
                                                            t._v(
                                                              '\n\t\t\t\t\t\t\t(' +
                                                                t._s(i.fee) +
                                                                '$) (' +
                                                                t._s(i.length) +
                                                                'M)\n\t\t\t\t\t\t'
                                                            ),
                                                          ]
                                                        ),
                                                  ],
                                                  1
                                                );
                                              }),
                                              1
                                            ),
                                          ],
                                          1
                                        ),
                                      ],
                                      1
                                    );
                                  }),
                                  1
                                ),
                              ],
                              1
                            ),
                          ],
                          1
                        ),
                        n(
                          'b-col',
                          {
                            attrs: {
                              cols: '6',
                            },
                          },
                          [
                            n(
                              'div',
                              {
                                staticClass:
                                  'table-responsive overflow-auto convictions-summary-table',
                              },
                              [
                                n(
                                  'table',
                                  {
                                    staticClass: 'table',
                                  },
                                  [
                                    n(
                                      'thead',
                                      {
                                        staticClass:
                                          'convictions-summary-table-header',
                                      },
                                      [
                                        n('tr', [
                                          n(
                                            'th',
                                            {
                                              attrs: {
                                                scope: 'col',
                                              },
                                            },
                                            [t._v('#')]
                                          ),
                                          n(
                                            'th',
                                            {
                                              attrs: {
                                                scope: 'col',
                                              },
                                            },
                                            [t._v('Nazwa')]
                                          ),
                                          n(
                                            'th',
                                            {
                                              attrs: {
                                                scope: 'col',
                                              },
                                            },
                                            [t._v('Ilość')]
                                          ),
                                          n(
                                            'th',
                                            {
                                              attrs: {
                                                scope: 'col',
                                              },
                                            },
                                            [t._v('Kara')]
                                          ),
                                          n(
                                            'th',
                                            {
                                              attrs: {
                                                scope: 'col',
                                              },
                                            },
                                            [t._v('Miesiące')]
                                          ),
                                          n(
                                            'th',
                                            {
                                              attrs: {
                                                scope: 'col',
                                              },
                                            },
                                            [t._v('Usuń')]
                                          ),
                                        ]),
                                      ]
                                    ),
                                    n(
                                      'tbody',
                                      [
                                        n('tr', [
                                          n('td'),
                                          n(
                                            'td',
                                            [
                                              n('b-form-input', {
                                                attrs: {
                                                  type: 'string',
                                                  size: 'sm',
                                                  min: '1',
                                                  max: '150',
                                                },
                                                model: {
                                                  value:
                                                    t.convictionPageData
                                                      .customConviction.name,
                                                  callback: function (e) {
                                                    t.$set(
                                                      t.convictionPageData
                                                        .customConviction,
                                                      'name',
                                                      e
                                                    );
                                                  },
                                                  expression:
                                                    'convictionPageData.customConviction.name',
                                                },
                                              }),
                                            ],
                                            1
                                          ),
                                          n('td'),
                                          n(
                                            'td',
                                            [
                                              n('b-form-input', {
                                                attrs: {
                                                  type: 'number',
                                                  size: 'sm',
                                                  min: '1',
                                                  max: '150',
                                                },
                                                model: {
                                                  value:
                                                    t.convictionPageData
                                                      .customConviction.fee,
                                                  callback: function (e) {
                                                    t.$set(
                                                      t.convictionPageData
                                                        .customConviction,
                                                      'fee',
                                                      e
                                                    );
                                                  },
                                                  expression:
                                                    'convictionPageData.customConviction.fee',
                                                },
                                              }),
                                            ],
                                            1
                                          ),
                                          n(
                                            'td',
                                            [
                                              n('b-form-input', {
                                                attrs: {
                                                  type: 'number',
                                                  size: 'sm',
                                                  min: '1',
                                                  max: '150',
                                                },
                                                model: {
                                                  value:
                                                    t.convictionPageData
                                                      .customConviction.length,
                                                  callback: function (e) {
                                                    t.$set(
                                                      t.convictionPageData
                                                        .customConviction,
                                                      'length',
                                                      e
                                                    );
                                                  },
                                                  expression:
                                                    'convictionPageData.customConviction.length',
                                                },
                                              }),
                                            ],
                                            1
                                          ),
                                          n(
                                            'td',
                                            [
                                              n(
                                                'b-button',
                                                {
                                                  attrs: {
                                                    variant: 'success ',
                                                    size: 'sm',
                                                  },
                                                  on: {
                                                    click: function (e) {
                                                      return t.addConviction(
                                                        t.convictionPageData
                                                          .customConviction
                                                      );
                                                    },
                                                  },
                                                },
                                                [t._v('Add')]
                                              ),
                                            ],
                                            1
                                          ),
                                        ]),
                                        t._l(
                                          this.convictionPageData
                                            .selectedConvictions,
                                          function (e, i) {
                                            return n(
                                              'tr',
                                              {
                                                key: i,
                                              },
                                              [
                                                n('td', [t._v(t._s(i))]),
                                                n('td', [t._v(t._s(e.name))]),
                                                n(
                                                  'td',
                                                  [
                                                    n('b-form-input', {
                                                      attrs: {
                                                        type: 'number',
                                                        size: 'sm',
                                                        min: '1',
                                                        max: '150',
                                                      },
                                                      model: {
                                                        value: e.times,
                                                        callback: function (n) {
                                                          t.$set(e, 'times', n);
                                                        },
                                                        expression:
                                                          'item.times',
                                                      },
                                                    }),
                                                  ],
                                                  1
                                                ),
                                                n('td', [
                                                  t._v(
                                                    t._s(t.calculateFee(e)) +
                                                      '$'
                                                  ),
                                                ]),
                                                n('td', [
                                                  t._v(
                                                    t._s(t.calculateLength(e))
                                                  ),
                                                ]),
                                                n(
                                                  'td',
                                                  [
                                                    n(
                                                      'b-button',
                                                      {
                                                        attrs: {
                                                          variant: 'danger',
                                                          size: 'sm',
                                                        },
                                                        on: {
                                                          click: function (n) {
                                                            return t.deleteConviction(
                                                              e
                                                            );
                                                          },
                                                        },
                                                      },
                                                      [t._v('Usuń')]
                                                    ),
                                                  ],
                                                  1
                                                ),
                                              ]
                                            );
                                          }
                                        ),
                                      ],
                                      2
                                    ),
                                    n('tfoot', [
                                      n('tr', [
                                        n('td'),
                                        n('td'),
                                        n('td', [t._v('Podsumowanie')]),
                                        n(
                                          'td',
                                          [
                                            n(
                                              'b-badge',
                                              {
                                                attrs: {
                                                  variant: 'success',
                                                },
                                              },
                                              [
                                                t._v(
                                                  t._s(t.calculateTotalFee()) +
                                                    '$'
                                                ),
                                              ]
                                            ),
                                          ],
                                          1
                                        ),
                                        n(
                                          'td',
                                          [
                                            n(
                                              'b-badge',
                                              {
                                                attrs: {
                                                  variant: 'danger',
                                                },
                                              },
                                              [
                                                t._v(
                                                  ' ' +
                                                    t._s(
                                                      t.calculateTotalLength()
                                                    )
                                                ),
                                              ]
                                            ),
                                          ],
                                          1
                                        ),
                                      ]),
                                    ]),
                                  ]
                                ),
                              ]
                            ),
                            n(
                              'b-row',
                              [
                                n(
                                  'b-col',
                                  [
                                    n('b-form-textarea', {
                                      attrs: {
                                        id: 'convictions-summary-textarea',
                                        rows: '3',
                                        'max-rows': '6',
                                        readonly: '',
                                      },
                                      model: {
                                        value: t.getConvictionSummary,
                                        callback: function (e) {
                                          t.getConvictionSummary = e;
                                        },
                                        expression: 'getConvictionSummary',
                                      },
                                    }),
                                  ],
                                  1
                                ),
                              ],
                              1
                            ),
                            n(
                              'b-row',
                              [
                                n(
                                  'b-col',
                                  [
                                    n(
                                      'span',
                                      {
                                        staticClass: 'police-text',
                                      },
                                      [t._v('Notatka')]
                                    ),
                                    n(
                                      'b-form-group',
                                      {
                                        attrs: {
                                          state: t.noteState,
                                          'invalid-feedback':
                                            t.noteInvalidFeedback,
                                        },
                                      },
                                      [
                                        n('b-form-textarea', {
                                          attrs: {
                                            rows: '3',
                                            'max-rows': '6',
                                            placeholder:
                                              'Dopisz dodatkowe informacje',
                                            state: t.noteState,
                                          },
                                          model: {
                                            value:
                                              t.convictionPageData
                                                .convictionNote,
                                            callback: function (e) {
                                              t.$set(
                                                t.convictionPageData,
                                                'convictionNote',
                                                e
                                              );
                                            },
                                            expression:
                                              'convictionPageData.convictionNote',
                                          },
                                        }),
                                      ],
                                      1
                                    ),
                                  ],
                                  1
                                ),
                              ],
                              1
                            ),
                            n(
                              'b-row',
                              [
                                n(
                                  'b-col',
                                  [
                                    n('b-form-input', {
                                      attrs: {
                                        type: 'string',
                                        size: 'sm',
                                        min: '1',
                                        max: '255',
                                        placeholder: 'Wystawiający',
                                      },
                                      model: {
                                        value:
                                          t.convictionPageData
                                            .convictionsAuthors,
                                        callback: function (e) {
                                          t.$set(
                                            t.convictionPageData,
                                            'convictionsAuthors',
                                            e
                                          );
                                        },
                                        expression:
                                          'convictionPageData.convictionsAuthors',
                                      },
                                    }),
                                  ],
                                  1
                                ),
                              ],
                              1
                            ),
                            n(
                              'b-row',
                              {
                                staticClass: 'mt-1',
                              },
                              [
                                n(
                                  'b-col',
                                  [
                                    n(
                                      'b-button',
                                      {
                                        staticClass: 'police-button',
                                        attrs: {
                                          variant: 'primary',
                                        },
                                        on: {
                                          click: t.addNewConviction,
                                        },
                                      },
                                      [t._v('Wystaw wyrok')]
                                    ),
                                  ],
                                  1
                                ),
                              ],
                              1
                            ),
                          ],
                          1
                        ),
                      ],
                      1
                    ),
                  ],
                  1
                ),
          ],
          1
        );
      },
      U = [],
      $ =
        (n('6762'),
        n('2fdb'),
        n('ac4d'),
        n('8a81'),
        n('ac6a'),
        n('7514'),
        {
          name: 'newConvictionPage',
          data: function () {
            return {
              convictionName: '',
              convictionsSummary: '',
            };
          },
          methods: {
            addConviction: function (t) {
              var e = t.name;
              if (null != e && 0 != e.trim().length) {
                if (
                  this.convictionPageData.selectedConvictions.some(function (
                    t
                  ) {
                    return t.name == e;
                  })
                ) {
                  var n = this.convictionPageData.selectedConvictions.find(
                    function (t) {
                      return t.name == e;
                    }
                  );
                  n.times++;
                } else
                  this.convictionPageData.selectedConvictions.push({
                    name: e,
                    length: t.length,
                    fee: t.fee,
                    times: 1,
                  });
                this.resetCustomConviction();
              } else
                this.$bvToast.toast('Nazw wyroku nie może być pusta.', {
                  title: 'Wystąpił błąd.',
                  autoHideDelay: 3500,
                  variant: 'danger',
                  appendToast: !0,
                });
            },
            resetCustomConviction: function () {
              this.convictionPageData.customConviction = {
                name: '',
                fee: 0,
                length: 0,
                times: 1,
              };
            },
            deleteConviction: function (t) {
              null != t &&
                (this.convictionPageData.selectedConvictions =
                  this.convictionPageData.selectedConvictions.filter(function (
                    e
                  ) {
                    return e.name != t.name;
                  }));
            },
            calculateFee: function (t) {
              return t.times * t.fee;
            },
            calculateLength: function (t) {
              return t.times * t.length;
            },
            calculateTotalFee: function () {
              var t = this,
                e = 0;
              return (
                this.convictionPageData.selectedConvictions.forEach(function (
                  n
                ) {
                  return (e += t.calculateFee(n));
                }),
                e
              );
            },
            calculateTotalLength: function () {
              var t = this,
                e = 0;
              return (
                this.convictionPageData.selectedConvictions.forEach(function (
                  n
                ) {
                  return (e += t.calculateLength(n));
                }),
                e
              );
            },
            generateCrimesText: function () {
              return this.convictionPageData.selectedConvictions
                .map(function (t) {
                  return ''.concat(t.name, ' x').concat(t.times, ' | ');
                })
                .join('');
            },
            addNewConviction: function () {
              var t = this.getCitizen;
              if (null != t && null != t.name) {
                var e = this.$store.getters.getUser;
                if (null != e) {
                  var n = this.calculateTotalFee(),
                    i = this.calculateTotalLength(),
                    o = this.generateCrimesText();
                  null == o || o.length <= 0
                    ? this.$bvToast.toast(
                        'Aby kontynuować musisz wybrać przynajmniej jedno przestępstwo.',
                        {
                          title: 'Wystąpił błąd.',
                          autoHideDelay: 3500,
                          variant: 'danger',
                          appendToast: !0,
                        }
                      )
                    : ((o += this.convictionPageData.convictionsAuthors),
                      this.$policeApi.addNewCitizenConviction(
                        t.id,
                        t.name,
                        e.name,
                        o,
                        this.convictionPageData.convictionNote,
                        n,
                        i
                      ),
                      this.$store.dispatch('addNewCitizenConviction'),
                      this.$router.push({
                        name: 'searchCitizensPage',
                      }));
                } else
                  this.$bvToast.toast('Wystąpił błąd, nie jesteś zalogowany.', {
                    title: 'Wystąpił błąd.',
                    autoHideDelay: 3500,
                    variant: 'danger',
                    appendToast: !0,
                  });
              } else
                this.$bvToast.toast(
                  'Wystąpił błąd, aby wystawić wyrok trzeba najpierw wyszukać obywatela.',
                  {
                    title: 'Wystąpił błąd.',
                    autoHideDelay: 3500,
                    variant: 'danger',
                    appendToast: !0,
                  }
                );
            },
          },
          computed: {
            getCitizen: function () {
              return this.$store.state.searchedCitizen;
            },
            convictionPageData: function () {
              return this.$store.state.convictionPageData;
            },
            filteredConvictions: function () {
              var t = this,
                e = [],
                n = this.$store.state.convictions,
                i = !0,
                o = !1,
                a = void 0;
              try {
                for (
                  var r, c = n[Symbol.iterator]();
                  !(i = (r = c.next()).done);
                  i = !0
                ) {
                  var s = r.value,
                    l = s.categoryName,
                    u = s.color,
                    d = s.items,
                    m = {
                      categoryName: l,
                      color: u,
                      items: d.filter(function (e) {
                        var n = e.name;
                        return n
                          .toLowerCase()
                          .includes(t.convictionName.toLowerCase());
                      }),
                    };
                  m.items.length && e.push(m);
                }
              } catch (h) {
                (o = !0), (a = h);
              } finally {
                try {
                  i || null == c.return || c.return();
                } finally {
                  if (o) throw a;
                }
              }
              return e;
            },
            getConvictionSummary: {
              get: function () {
                var t = this.convictionPageData.selectedConvictions
                    .map(function (t) {
                      return ''.concat(t.name, ' x').concat(t.times, ' |');
                    })
                    .join('\n'),
                  e = '\n'
                    .concat(this.calculateTotalFee(), '$ ')
                    .concat(this.calculateTotalLength(), ' miesięcy');
                return e.includes('0$ 0') || (t += e), t;
              },
              set: function (t) {},
            },
            noteState: function () {
              return this.convictionPageData.convictionNote.length <= 254;
            },
            noteInvalidFeedback: function () {
              return this.noteState ? '' : 'Maksymalna ilość znaków to 254';
            },
          },
        }),
      M = $,
      R = (n('7628'), Object(s['a'])(M, Z, U, !1, null, 'fe4bb57e', null)),
      F = R.exports;
    i['default'].use(d['a']);
    var K = new d['a']({
      mode: 'hash',
      base: '',
      routes: [
        {
          path: '/',
          component: V,
          children: [
            {
              path: '',
              name: 'policeMdcHomePage',
              component: function () {
                return n.e('chunk-810c293a').then(n.bind(null, '4de4'));
              },
              meta: {
                requiresAuth: !0,
              },
            },
            {
              path: 'login',
              name: 'loginPage',
              component: function () {
                return n.e('chunk-237795f2').then(n.bind(null, '3bea'));
              },
            },
            {
              path: 'searchCitizens',
              name: 'searchCitizensPage',
              component: function () {
                return n.e('chunk-5b01a659').then(n.bind(null, '6e44'));
              },
              meta: {
                requiresAuth: !0,
              },
            },
            {
              path: 'newConviction',
              name: 'newConvictionPage',
              component: F,
              meta: {
                requiresAuth: !0,
              },
            },
            {
              path: 'searchVehicles',
              name: 'searchVehiclesPage',
              component: function () {
                return n.e('chunk-234381ab').then(n.bind(null, '2b15'));
              },
              meta: {
                requiresAuth: !0,
              },
            },
            {
              path: 'vehicleWarrants',
              name: 'vehicleWarrantsPage',
              component: function () {
                return n.e('chunk-2d0e95c4').then(n.bind(null, '8ccf'));
              },
              meta: {
                requiresAuth: !0,
              },
            },
            {
              path: 'citizenWarrants',
              name: 'citizenWarrantsPage',
              component: function () {
                return n.e('chunk-2d0a5510').then(n.bind(null, '09d5'));
              },
              meta: {
                requiresAuth: !0,
              },
            },
          ],
        },
      ],
    });
    K.beforeEach(function (t, e, n) {
      t.matched.some(function (t) {
        return t.meta.requiresAuth;
      })
        ? y.getters.getUser
          ? n()
          : n({
              path: 'login',
            })
        : n();
    });
    var H = K,
      J = n('d225'),
      B = n('b0b4'),
      q = 'http://policemdc/',
      G = (function () {
        function t() {
          var e = this;
          Object(J['a'])(this, t),
            window.addEventListener('message', function (t) {
              var n = t.data.event;
              void 0 !== n &&
                'function' === typeof e['on' + n] &&
                (e['on' + n](t.data), console.log('Data from event = ' + n));
            });
        }
        return (
          Object(B['a'])(t, [
            {
              key: 'loadConfig',
              value: (function () {
                var t = Object(m['a'])(
                  regeneratorRuntime.mark(function t() {
                    var e, n, i;
                    return regeneratorRuntime.wrap(function (t) {
                      while (1)
                        switch ((t.prev = t.next)) {
                          case 0:
                            return (
                              (t.next = 2),
                              window.jQuery.get('/config/config.json')
                            );
                          case 2:
                            return (
                              (e = t.sent),
                              console.log(
                                'Config repsonse = '.concat(JSON.stringify(e))
                              ),
                              (n = JSON.parse(e)),
                              (t.next = 8),
                              D.dispatch('loadConfig', n)
                            );
                          case 8:
                            t.next = 13;
                            break;
                          case 10:
                            return (
                              (i = e),
                              (t.next = 13),
                              D.dispatch('loadConfig', i)
                            );
                          case 13:
                          case 'end':
                            return t.stop();
                        }
                    }, t);
                  })
                );

                function e() {
                  return t.apply(this, arguments);
                }
                return e;
              })(),
            },
            {
              key: 'post',
              value: (function () {
                var t = Object(m['a'])(
                  regeneratorRuntime.mark(function t(e, n) {
                    var i, o;
                    return regeneratorRuntime.wrap(function (t) {
                      while (1)
                        switch ((t.prev = t.next)) {
                          case 0:
                            return (
                              (i = void 0 === n ? '{}' : JSON.stringify(n)),
                              (t.next = 3),
                              window.jQuery.post(q + e, i)
                            );
                          case 3:
                            return (
                              (o = t.sent),
                              console.log(
                                'Emitting event to NUI named '
                                  .concat(e, ' with data ')
                                  .concat(i)
                              ),
                              console.log(
                                'RESPONSE = '.concat(JSON.stringify(o))
                              ),
                              t.abrupt('return', JSON.parse(o))
                            );
                          case 7:
                          case 'end':
                            return t.stop();
                        }
                    }, t);
                  })
                );

                function e(e, n) {
                  return t.apply(this, arguments);
                }
                return e;
              })(),
            },
            {
              key: 'closePoliceMdc',
              value: function () {
                y.commit('setPoliceTabletVisible', !1),
                  this.post('closePoliceMdc');
              },
            },
            {
              key: 'onShowPoliceTablet',
              value: function (t) {
                y.commit('setPoliceTabletVisible', t.isVisible);
              },
            },
            {
              key: 'onLoggedInPoliceTablet',
              value: function (t) {
                y.commit('setUserData', t.user);
              },
            },
            {
              key: 'onFoundCitizen',
              value: function (t) {
                y.commit('setSearchedCitizenData', t.citizen);
              },
            },
            {
              key: 'onFoundManyCitizens',
              value: function (t) {
                y.commit('setSearchedCitizenCandidates', t.citizens);
              },
            },
            {
              key: 'onLoadCitizensWarrants',
              value: function (t) {
                y.commit('setCitizensWarrants', t.warrants);
              },
            },
            {
              key: 'onLoadVehicleWarrants',
              value: function (t) {
                y.commit('setVehicleWarrants', t.warrants);
              },
            },
            {
              key: 'onLoadConvictionCategories',
              value: function (t) {
                y.commit('setConvictions', t.convictions);
              },
            },
            {
              key: 'onLoadMdcAllTags',
              value: function (t) {
                y.commit('setMdcTags', t.tags);
              },
            },
            {
              key: 'onLoadConfig',
              value: function (t) {
                y.commit('SET_DEPARTMENTS', t.departments);
              },
            },
            {
              key: 'addNewCitizenNote',
              value: (function () {
                var t = Object(m['a'])(
                  regeneratorRuntime.mark(function t(e) {
                    return regeneratorRuntime.wrap(
                      function (t) {
                        while (1)
                          switch ((t.prev = t.next)) {
                            case 0:
                              return (
                                (t.next = 2), this.post('addNewCitizenNote', e)
                              );
                            case 2:
                              return t.abrupt('return', t.sent);
                            case 3:
                            case 'end':
                              return t.stop();
                          }
                      },
                      t,
                      this
                    );
                  })
                );

                function e(e) {
                  return t.apply(this, arguments);
                }
                return e;
              })(),
            },
            {
              key: 'addNewCitizenConviction',
              value: (function () {
                var t = Object(m['a'])(
                  regeneratorRuntime.mark(function t(e, n, i, o, a, r, c) {
                    return regeneratorRuntime.wrap(
                      function (t) {
                        while (1)
                          switch ((t.prev = t.next)) {
                            case 0:
                              y.dispatch('saveCitizenConviction', {
                                citizenId: e,
                                citizenName: n,
                                userName: i,
                                crimes: o,
                                note: a,
                                totalConvictionFee: r,
                                totalConvictionLength: c,
                              }),
                                this.post(
                                  'addNewCitizenConviction',
                                  y.getters.getNewConviction
                                );
                            case 2:
                            case 'end':
                              return t.stop();
                          }
                      },
                      t,
                      this
                    );
                  })
                );

                function e(e, n, i, o, a, r, c) {
                  return t.apply(this, arguments);
                }
                return e;
              })(),
            },
            {
              key: 'onFoundVehicle',
              value: function (t) {
                y.commit('setSearchedVehicle', t.vehicle);
              },
            },
            {
              key: 'addNewVehicleNote',
              value: function (t) {
                return this.post('addNewVehicleNote', t);
              },
            },
            {
              key: 'getCitizensWarrantsList',
              value: function () {
                var t = this.post('getCitizensWarrantsList');
                return 'error' != t;
              },
            },
            {
              key: 'getVehiclesWarrantsList',
              value: function () {
                var t = this.post('getVehiclesWarrantsList');
                return 'error' != t;
              },
            },
          ]),
          t
        );
      })(),
      Q = new G(),
      Y = Q,
      X = n('5f5b');
    n('f9e3'), n('2dd8');
    (i['default'].config.productionTip = !1),
      (i['default'].prototype.$policeApi = Y),
      i['default'].use(X['a']),
      new i['default']({
        router: H,
        store: y,
        render: function (t) {
          return t(u);
        },
      }).$mount('#app');
  },
  '64a9': function (t, e, n) {},
  7628: function (t, e, n) {
    'use strict';
    var i = n('ee3b'),
      o = n.n(i);
    o.a;
  },
  '7a1a': function (t, e, n) {},
  '8c64': function (t, e, n) {
    t.exports = n.p + 'img/dojLogo.png';
  },
  '916a': function (t, e, n) {},
  a4f0: function (t, e, n) {},
  bff7: function (t, e, n) {
    t.exports = n.p + 'img/lssdLogo.png';
  },
  ee3b: function (t, e, n) {},
  f8d3: function (t, e, n) {
    'use strict';
    var i = n('7a1a'),
      o = n.n(i);
    o.a;
  },
});
