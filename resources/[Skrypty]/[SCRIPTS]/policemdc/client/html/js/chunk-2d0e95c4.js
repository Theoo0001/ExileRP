(window["webpackJsonp"] = window["webpackJsonp"] || []).push([
    ["chunk-2d0e95c4"], {
        "8ccf": function(e, t, a) {
            "use strict";
            a.r(t);
            var s = function() {
                    var e = this,
                        t = e.$createElement,
                        a = e._self._c || t;
                    return a("b-row", {
                        staticClass: "add-warrants add-vehicle-warrant"
                    }, [a("b-col", {
                        attrs: {
                            cols: "12"
                        }
                    }, [a("b-row", [a("b-col", {
                        staticClass: "text-center"
                    }, [a("p", {
                        staticClass: "police-text"
                    }, [e._v("POSZUKIWANE POJAZDY")])])], 1), a("b-row", [a("b-col", {
                        staticClass: "text-center"
                    }, [a("b-button", {
                        staticClass: "police-button",
                        attrs: {
                            variant: "primary"
                        },
                        on: {
                            click: e.getCitizenWarrants
                        }
                    }, [e._v("Odśwież")])], 1)], 1)], 1), a("b-col", {
                        attrs: {
                            cols: "12"
                        }
                    }, [a("b-row", {
                        staticClass: "justify-content-center m-3"
                    }, [e.getVehiclesWarrantsList ? a("b-col", {
                        staticClass: "table-responsive warrants-table-container pt-3",
                        attrs: {
                            cols: "10"
                        }
                    }, [a("b-table", {
                        staticClass: "warrants-table",
                        attrs: {
                            id: "vehicle-warrants",
                            items: e.getVehiclesWarrantsList,
                            fields: e.fields,
                            "per-page": e.perPage,
                            "current-page": e.currentPage,
                            "sticky-header": "25rem"
                        },
                        scopedSlots: e._u([{
                            key: "[owner]",
                            fn: function(t) {
                                return [a("p", [a("a", {
                                    directives: [{
                                        name: "b-tooltip",
                                        rawName: "v-b-tooltip"
                                    }],
                                    staticClass: "police-link",
                                    attrs: {
                                        title: "Kliknij aby wyszukać"
                                    },
                                    on: {
                                        click: function(a) {
                                            return e.searchVehicleOwner(t.item)
                                        }
                                    }
                                }, [e._v(e._s(t.item.owner))])])]
                            }
                        }, {
                            key: "[plateText]",
                            fn: function(t) {
                                return [a("p", [a("a", {
                                    directives: [{
                                        name: "b-tooltip",
                                        rawName: "v-b-tooltip"
                                    }],
                                    staticClass: "police-link",
                                    attrs: {
                                        title: "Kliknij aby wyszukać"
                                    },
                                    on: {
                                        click: function(a) {
                                            return e.searchVehicle(t.item)
                                        }
                                    }
                                }, [e._v(e._s(t.item.plateText))])])]
                            }
                        }], null, !1, 1341766152)
                    }), a("b-pagination", {
                        attrs: {
                            align: "center",
                            "total-rows": e.totalRows,
                            "per-page": e.perPage,
                            "aria-controls": "vehicle-warrants"
                        },
                        model: {
                            value: e.currentPage,
                            callback: function(t) {
                                e.currentPage = t
                            },
                            expression: "currentPage"
                        }
                    }), a("p", {
                        staticClass: "mt-3 text-center police-text"
                    }, [e._v("Aktualna strona: " + e._s(e.currentPage))])], 1) : e._e()], 1)], 1)], 1)
                },
                i = [],
                r = a("4eaa"),
                n = {
                    data: function() {
                        return {
                            perPage: 4,
                            currentPage: 1,
                            lastSearchPressedButtonTime: (new Date).getTime() - this.cooldownTime,
                            cooldownTime: 5e3,
                            fields: [{
                                key: "owner",
                                label: "Właściciel",
                                sortable: !0,
                                thClass: "warrants-header"
                            }, {
                                key: "plateText",
                                label: "Numer rejestracji",
                                sortable: !0,
                                thClass: "warrants-header"
                            }, {
                                key: "model",
                                label: "Model",
                                sortable: !0,
                                thClass: "warrants-header"
                            }]
                        }
                    },
                    beforeMount: function() {
                        this.$policeApi.getVehiclesWarrantsList()
                    },
                    methods: {
                        getCitizenWarrants: function() {
                            if (Object(r["a"])(this.cooldownTime, this.lastSearchPressedButtonTime) > 0) this.$bvToast.toast("Spokojnie kowboju, spróbuj ponownie za ".concat(Object(r["a"])(this.cooldownTime, this.lastSearchPressedButtonTime), "s"), {
                                title: "Spokojnie",
                                autoHideDelay: 3500,
                                variant: "danger",
                                appendToast: !0
                            });
                            else {
                                this.lastSearchPressedButtonTime = (new Date).getTime();
                                var e = this.$policeApi.getVehiclesWarrantsList();
                                e || this.$bvToast.toast("Wystąpił błąd z pobieraniem listy poszukiwanych pojazdów.", {
                                    title: "Wystąpił błąd",
                                    autoHideDelay: 3500,
                                    variant: "danger",
                                    appendToast: !0
                                })
                            }
                        },
                        searchVehicleOwner: function(e) {
                            null != e && null != e.owner && (this.$store.commit("SET_SEARCH_CITIZEN_NAME", e.owner), this.$policeApi.post("policeMdcSearchForCitizen", {
                                citizenName: e.owner
                            }), this.$router.push({
                                name: "searchCitizensPage"
                            }))
                        },
                        searchVehicle: function(e) {
                            null != e && null != e.plateText && (this.$store.commit("SET_SEARCH_VEHICLE_PLATE_TEXT", e.plateText), this.$policeApi.post("policeMdcSearchForVehicle", {
                                vehiclePlateText: e.plateText
                            }), this.$router.push({
                                name: "searchVehiclesPage"
                            }))
                        }
                    },
                    computed: {
                        getVehiclesWarrantsList: function() {
                            return this.$store.getters.getVehiclesWarrantsList
                        },
                        totalRows: function() {
                            return this.$store.getters.getVehiclesWarrantsList.length
                        }
                    }
                },
                o = n,
                l = a("2877"),
                c = Object(l["a"])(o, s, i, !1, null, null, null);
            t["default"] = c.exports
        }
    }
]);