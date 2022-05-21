(window["webpackJsonp"] = window["webpackJsonp"] || []).push([
    ["chunk-237795f2"], {
        "3bea": function(t, e, i) {
            "use strict";
            i.r(e);
            var s = function() {
                    var t = this,
                        e = t.$createElement,
                        i = t._self._c || e;
                    return i("b-row", {
                        staticClass: "justify-content-center align-items-center my-auto mx-auto p-5"
                    }, [i("b-col", {
                        attrs: {
                            cols: "8 m-5 text-center"
                        }
                    }, [i("p", {
                        staticClass: "police-text"
                    }, [t._v("Witaj na stronie departamentu policji, aby kontynuować musisz potwierdzić swoją tożsamość")])]), i("b-col", {
                        staticClass: "text-center",
                        attrs: {
                            cols: "8"
                        }
                    }, [i("p", {
                        staticClass: "police-text"
                    }, [t._v(t._s(t.getLoadingText))]), i("b-col", {
                        staticClass: "fingerprint-container",
                        on: {
                            mousedown: t.mouseDown,
                            mouseup: t.mouseUp
                        }
                    }, [t.isSendingRequest ? i("b-spinner", {
                        staticStyle: {
                            width: "5rem",
                            height: "5rem"
                        },
                        attrs: {
                            label: "Large Spinner"
                        }
                    }) : i("svg", {
                        staticClass: "fingerprint",
                        class: {
                            active: t.authTimer
                        },
                        attrs: {
                            xmlns: "http://www.w3.org/2000/svg",
                            viewBox: "-1.5 -1.5 136.63 136.56",
                            width: "136.63",
                            height: "136.56"
                        }
                    }, [i("path", {
                        staticClass: "original",
                        attrs: {
                            d: "M74.79 8.76C34.79 5.41 8.15 33.6 8.2 67.06c.02 9.4 4.71 18.2-3.08 26.3M95.66 6.84C64.75-6.62 35.16-.37 12.83 27.07m92.5-14.8c18.89 14.55 28.33 31.7 28.3 55.56M7.33 36.48C-.21 51.34-1.78 65.35 1.96 82.91m15.46-24.84c11.03-56.46 92.3-55.76 99.67 4.91M49 29.02c16.4-7.37 31.33-5.39 44.7 5.88m-9.5-23.96c34.23 11.28 46.91 41.4 41.55 86.97M19.31 114.08c5.28-4.5 10.26-10.33 12.77-17.5m-5.93 22.53c15.22-12.49 18.45-31.24 16.52-44.59-5.3-27.22 16.68-33.82 26.82-32.75m-60.06 59c13.42-12.83 7.13-24.08 7.23-32.41m-2.3 39.33C42.6 79.8 7.64 65.8 40.34 34.52m.44 93.96a60.94 60.94 0 0 0 14.6-22.67M33.32 124.1c13.22-12.7 20.85-31.39 17.7-50.9m18.23 60.37c7.88-12.08 13-25.79 15.32-41.2m.55-9.96c2.77-42.91-32.4-36.83-34.59-18.61m63.56 50.8c3.44-14.48 5.28-28.43 4.18-41.01m-27.51 55.7c3.05-6.22 6.01-13.64 7.48-20.15m3.93 14.49c11.26-26.47 9.82-68.08-1.45-81.57m-51.14 89.23c15.1-16.79 21.81-39.44 17.4-64.39m-8.1 66.06c21.14-28.19 18.43-54.84 16.26-66.68-2.17-11.83-16.63-9.3-16.27 1.18.37 10.48 2.53 14.1-.36 27.83m21.1 37.03c20.46-36.82 16.97-79.29-.42-87.57m20.9 55.5c15.34-83.72-60.42-79.88-66.48-38.07-1.34 12.78 2.22 14.56.76 25.71",
                            fill: "none",
                            "stroke-width": "3",
                            stroke: "#ddd",
                            "stroke-linecap": "round",
                            "stroke-miterlimit": "3"
                        }
                    }), i("linearGradient", {
                        attrs: {
                            id: "a",
                            x1: "49.4%",
                            y1: "-3.33%",
                            x2: "49.87%",
                            y2: "102.85%"
                        }
                    }, [i("stop", {
                        attrs: {
                            offset: "0%",
                            "stop-color": "#b279f7"
                        }
                    }), i("stop", {
                        attrs: {
                            offset: "90%",
                            "stop-color": "#4b52db"
                        }
                    })], 1), i("path", {
                        staticClass: "clone",
                        attrs: {
                            d: "M74.79 8.76C34.79 5.41 8.15 33.6 8.2 67.06c.02 9.4 4.71 18.2-3.08 26.3M95.66 6.84C64.75-6.62 35.16-.37 12.83 27.07m92.5-14.8c18.89 14.55 28.33 31.7 28.3 55.56M7.33 36.48C-.21 51.34-1.78 65.35 1.96 82.91m15.46-24.84c11.03-56.46 92.3-55.76 99.67 4.91M49 29.02c16.4-7.37 31.33-5.39 44.7 5.88m-9.5-23.96c34.23 11.28 46.91 41.4 41.55 86.97M19.31 114.08c5.28-4.5 10.26-10.33 12.77-17.5m-5.93 22.53c15.22-12.49 18.45-31.24 16.52-44.59-5.3-27.22 16.68-33.82 26.82-32.75m-60.06 59c13.42-12.83 7.13-24.08 7.23-32.41m-2.3 39.33C42.6 79.8 7.64 65.8 40.34 34.52m.44 93.96a60.94 60.94 0 0 0 14.6-22.67M33.32 124.1c13.22-12.7 20.85-31.39 17.7-50.9m18.23 60.37c7.88-12.08 13-25.79 15.32-41.2m.55-9.96c2.77-42.91-32.4-36.83-34.59-18.61m63.56 50.8c3.44-14.48 5.28-28.43 4.18-41.01m-27.51 55.7c3.05-6.22 6.01-13.64 7.48-20.15m3.93 14.49c11.26-26.47 9.82-68.08-1.45-81.57m-51.14 89.23c15.1-16.79 21.81-39.44 17.4-64.39m-8.1 66.06c21.14-28.19 18.43-54.84 16.26-66.68-2.17-11.83-16.63-9.3-16.27 1.18.37 10.48 2.53 14.1-.36 27.83m21.1 37.03c20.46-36.82 16.97-79.29-.42-87.57m20.9 55.5c15.34-83.72-60.42-79.88-66.48-38.07-1.34 12.78 2.22 14.56.76 25.71",
                            fill: "none",
                            "stroke-width": "3",
                            stroke: "url(#a)",
                            "stroke-linecap": "round",
                            "stroke-miterlimit": "3",
                            "stroke-dasharray": "178",
                            "stroke-dashoffset": "178"
                        }
                    })], 1)], 1)], 1)], 1)
                },
                n = [],
                o = (i("96cf"), i("3b8d")),
                a = {
                    name: "loginPage",
                    data: function() {
                        return {
                            authTimer: null,
                            isSendingRequest: !1
                        }
                    },
                    methods: {
                        tryToLogin: function() {
                            var t = Object(o["a"])(regeneratorRuntime.mark(function t() {
                                var e;
                                return regeneratorRuntime.wrap(function(t) {
                                    while (1) switch (t.prev = t.next) {
                                        case 0:
                                            this.isSendingRequest = !0, console.log("CALLING POLICE API"), e = this.$policeApi.post("policeTryToLogin"), "error" != e ? (this.isSendingRequest = !1, this.clearTimer()) : (this.$bvToast.toast("Nie udało się zalogować. Twoje odciski palców nie występują w bazie danych", {
                                                title: "Błąd logowania",
                                                autoHideDelay: 4500,
                                                variant: "danger",
                                                appendToast: !0
                                            }), this.isSendingRequest = !1, this.clearTimer());
                                        case 4:
                                        case "end":
                                            return t.stop()
                                    }
                                }, t, this)
                            }));

                            function e() {
                                return t.apply(this, arguments)
                            }
                            return e
                        }(),
                        mouseUp: function() {
                            this.isLoggedIn || this.isSendingRequest || (this.clearTimer(), console.log("Should clear timeout"))
                        },
                        mouseDown: function() {
                            this.isLoggedIn || this.isSendingRequest || (console.log("on mouse down"), this.authTimer = setTimeout(this.onFingerprintSuccess, 1650))
                        },
                        onFingerprintSuccess: function() {
                            this.isLoggedIn || this.isSendingRequest || (this.clearTimer(), this.tryToLogin())
                        },
                        clearTimer: function() {
                            clearTimeout(this.authTimer), this.authTimer = null
                        }
                    },
                    computed: {
                        isLoggedIn: function() {
                            return null != this.$store.getters.getUser
                        },
                        getLoadingText: function() {
                            return this.isSendingRequest ? "Trwa logowanie..." : "Przytrzymaj aby się zalogować"
                        }
                    }
                },
                r = a,
                c = (i("5efa"), i("2877")),
                u = Object(c["a"])(r, s, n, !1, null, "0ef338e9", null);
            e["default"] = u.exports
        },
        "5efa": function(t, e, i) {
            "use strict";
            var s = i("eefe"),
                n = i.n(s);
            n.a
        },
        eefe: function(t, e, i) {}
    }
]);