(window["webpackJsonp"] = window["webpackJsonp"] || []).push([
    ["chunk-810c293a"], {
        "4de4": function(t, a, e) {
            "use strict";
            e.r(a);
            var s = function() {
                    var t = this,
                        a = t.$createElement,
                        e = t._self._c || a;
                    return e("b-row", {
                        staticClass: "police-mdc-home p-5"
                    }, [e("b-col", [e("b-row", [e("b-col", [e("p", {
                        staticClass: "police-text"
                    }, [t._v(t._s(t.getUserName) + " witaj na oficjalnej stronie " + t._s(t.getDepartmentName))])])], 1), e("b-row", {
                        staticClass: "text-center"
                    }, [e("b-col", {
                        attrs: {
                            cols: "12"
                        }
                    }, [e("b-row", [e("b-col", [e("b-button", {
                        staticClass: "police-button big-button",
                        attrs: {
                            variant: "primary",
                            to: {
                                name: "searchCitizensPage"
                            }
                        }
                    }, [t._v("Wyszukaj obywatela")])], 1), e("b-col", [e("b-button", {
                        staticClass: "police-button big-button",
                        attrs: {
                            variant: "primary",
                            to: {
                                name: "searchVehiclesPage"
                            }
                        }
                    }, [t._v("Wyszukaj pojazd")])], 1)], 1)], 1), e("b-col", {
                        staticClass: "pt-5",
                        attrs: {
                            cols: "12"
                        }
                    }, [e("b-row", [e("b-col", [e("b-button", {
                        staticClass: "police-button big-button",
                        attrs: {
                            variant: "primary",
                            to: {
                                name: "citizenWarrantsPage"
                            }
                        }
                    }, [t._v("\n              Wyszukaj list gończy za obywatelem")])], 1), e("b-col", [e("b-button", {
                        staticClass: "police-button big-button",
                        attrs: {
                            variant: "primary",
                            to: {
                                name: "vehicleWarrantsPage"
                            }
                        }
                    }, [t._v("\n              Wyszukaj list gończy za pojazdem")])], 1)], 1)], 1)], 1)], 1)], 1)
                },
                o = [],
                n = {
                    name: "police-mdc-home",
                    computed: {
                        getUserName: function() {
                            return this.$store.getters.getUserName
                        },
                        getDepartmentName: function() {
                            return this.$store.getters.getDepartmentName
                        }
                    }
                },
                r = n,
                c = (e("c24d"), e("2877")),
                i = Object(c["a"])(r, s, o, !1, null, "4bb08230", null);
            a["default"] = i.exports
        },
        6174: function(t, a, e) {},
        c24d: function(t, a, e) {
            "use strict";
            var s = e("6174"),
                o = e.n(s);
            o.a
        }
    }
]);