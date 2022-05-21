(window["webpackJsonp"] = window["webpackJsonp"] || []).push([
    ["chunk-2d0a5510"], {
        "09d5": function(t, e, a) {
            "use strict";
            a.r(e);
            var i = function() {
                    var t = this,
                        e = t.$createElement,
                        a = t._self._c || e;
                    return a("b-row", {
                        staticClass: "add-warrants add-citizen-warrant"
                    }, [a("b-col", {
                        attrs: {
                            cols: "12"
                        }
                    }, [a("b-row", [a("b-col", {
                        staticClass: "text-center"
                    }, [a("p", {
                        staticClass: "police-text"
                    }, [t._v("POSZUKIWANI OBYWATELE")])])], 1), a("b-row", [a("b-col", {
                        staticClass: "text-center"
                    }, [a("b-button", {
                        staticClass: "police-button",
                        attrs: {
                            variant: "primary"
                        },
                        on: {
                            click: t.getCitizenWarrants
                        }
                    }, [t._v("Odśwież")])], 1)], 1)], 1), a("b-col", {
                        attrs: {
                            cols: "12"
                        }
                    }, [a("b-row", {
                        staticClass: "justify-content-center m-3"
                    }, [t.getCitizensWarrantsList ? a("b-col", {
                        staticClass: "table-responsive warrants-table-container pt-3",
                        attrs: {
                            cols: "10"
                        }
                    }, [a("b-table", {
                        staticClass: "warrants-table",
                        attrs: {
                            id: "citizen-warrants",
                            items: t.getCitizensWarrantsList,
                            fields: t.fields,
                            "per-page": t.perPage,
                            "current-page": t.currentPage,
                            "sticky-header": "25rem"
                        },
                        scopedSlots: t._u([{
                            key: "[citizenName]",
                            fn: function(e) {
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
                                            return t.searchCitizen(e.item)
                                        }
                                    }
                                }, [t._v(t._s(e.item.citizenName))])])]
                            }
                        }, {
                            key: "[photo]",
                            fn: function(e) {
                                return [a("div", {
                                    staticClass: "warrant-image"
                                }, [a("b-img", {
                                    attrs: {
                                        src: t.getProfileImage(e.item),
                                        fluid: "",
                                        rounded: ""
                                    }
                                })], 1)]
                            }
                        }], null, !1, 1829373355)
                    }), a("b-pagination", {
                        attrs: {
                            align: "center",
                            "total-rows": t.totalRows,
                            "per-page": t.perPage,
                            "aria-controls": "citizen-warrants"
                        },
                        model: {
                            value: t.currentPage,
                            callback: function(e) {
                                t.currentPage = e
                            },
                            expression: "currentPage"
                        }
                    }), a("p", {
                        staticClass: "mt-3 text-center police-text"
                    }, [t._v("Aktualna strona: " + t._s(t.currentPage))])], 1) : t._e()], 1)], 1)], 1)
                },
                s = [],
                r = a("4eaa"),
                n = {
                    name: "citizensWarrants",
                    data: function() {
                        return {
                            perPage: 4,
                            currentPage: 1,
                            lastSearchPressedButtonTime: (new Date).getTime() - this.cooldownTime,
                            cooldownTime: 5e3,
                            fields: [{
                                key: "photo",
                                label: "Zdjęcie",
                                thClass: "warrants-header"
                            }, {
                                key: "citizenName",
                                label: "Imię i nazwisko",
                                sortable: !0,
                                thClass: "warrants-header"
                            }, {
                                key: "sex",
                                label: "Płeć",
                                sortable: !0,
                                thClass: "warrants-header"
                            }, {
                                key: "birthdate",
                                label: "Data urodzenia",
                                sortable: !0,
                                thClass: "warrants-header"
                            }]
                        }
                    },
                    beforeMount: function() {
                        this.$policeApi.getCitizensWarrantsList()
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
                                var t = this.$policeApi.getCitizensWarrantsList();
                                t || this.$bvToast.toast("Wystąpił błąd z pobieraniem listy poszukiwanych obywateli.", {
                                    title: "Wystąpił błąd",
                                    autoHideDelay: 3500,
                                    variant: "danger",
                                    appendToast: !0
                                })
                            }
                        },
                        searchCitizen: function(t) {
                            null != t && null != t.citizenName && (this.$store.commit("SET_SEARCH_CITIZEN_NAME", t.citizenName), this.$store.commit("clearSearchedCitizenData"), this.$store.state.searchCitizenState = {
                                inProgress: !0,
                                notFoundError: !1
                            }, this.$policeApi.post("policeMdcSearchForCitizen", {
                                citizenName: t.citizenName
                            }), this.$router.push({
                                name: "searchCitizensPage"
                            }))
                        },
                        getProfileImage: function(t) {
                            return null == t.photo || t.photo.length <= 0 ? a("0121") : t.photo
                        }
                    },
                    computed: {
                        getCitizensWarrantsList: function() {
                            return this.$store.getters.getCitizensWarrantsList
                        },
                        totalRows: function() {
                            return this.$store.getters.getCitizensWarrantsList.length
                        }
                    }
                },
                o = n,
                c = a("2877"),
                l = Object(c["a"])(o, i, s, !1, null, null, null);
            e["default"] = l.exports
        }
    }
]);