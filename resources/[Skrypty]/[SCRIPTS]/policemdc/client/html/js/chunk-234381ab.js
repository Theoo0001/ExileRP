(window["webpackJsonp"] = window["webpackJsonp"] || []).push([
    ["chunk-234381ab"], {
        "19f6": function(e, t, a) {
            "use strict";
            var i = function() {
                    var e = this,
                        t = e.$createElement,
                        a = e._self._c || t;
                    return a("div", [a("b-col", {
                        staticClass: "mt-1 mb-2"
                    }, [a("b-button", {
                        staticClass: "police-button",
                        attrs: {
                            variant: "primary",
                            pill: "",
                            block: ""
                        },
                        on: {
                            click: e.addNewNote
                        }
                    }, [e._v("Dodaj nową notatkę")])], 1), e._l(e.notes, function(t, i) {
                        return a("b-col", {
                            key: i,
                            staticClass: "note-container mb-1"
                        }, [a("b-form-textarea", {
                            staticClass: "note-content",
                            attrs: {
                                plaintext: "",
                                value: t.text,
                                "max-rows": "3"
                            }
                        }), a("div", {
                            staticClass: "note-footer"
                        }, [a("span", {
                            staticClass: "note-author"
                        }, [e._v(e._s(t.addedBy))]), a("span", {
                            staticClass: "text-muted"
                        }, [e._v(" " + e._s(t.date) + " ")])])], 1)
                    })], 2)
                },
                s = [],
                n = {
                    props: {
                        notes: {
                            type: Array
                        }
                    },
                    methods: {
                        addNewNote: function() {
                            this.$emit("add-new-note")
                        }
                    }
                },
                o = n,
                r = (a("7655"), a("2877")),
                l = Object(r["a"])(o, i, s, !1, null, "1ceed9f8", null);
            t["a"] = l.exports
        },
        "259a": function(e, t, a) {},
        "2b15": function(e, t, a) {
            "use strict";
            a.r(t);
            var i = function() {
                    var e = this,
                        t = e.$createElement,
                        a = e._self._c || t;
                    return a("b-row", {
                        staticClass: "search-page search-vehicles"
                    }, [a("searchbar", {
                        attrs: {
                            searchString: e.getSearchVehiclePlateText,
                            searchTitle: "POJAZD"
                        },
                        on: {
                            "update-search-string": e.updateVehiclePlateText,
                            search: e.searchVehicle
                        }
                    }), a("b-col", {
                        attrs: {
                            cols: "12"
                        }
                    }, [e.searchInProgress() ? a("b-row", [a("div", {
                        staticClass: "text-center",
                        staticStyle: {
                            width: "100%"
                        }
                    }, [a("b-spinner", {
                        attrs: {
                            variant: "warning",
                            label: "InProgress"
                        }
                    })], 1)]) : e._e(), e.showNotFoundError() ? a("b-row", {
                        staticStyle: {
                            display: "flex",
                            "justify-content": "center"
                        }
                    }, [a("b-alert", {
                        attrs: {
                            variant: "danger",
                            show: ""
                        }
                    }, [e._v("Pojazd nie został znaleziony w bazie.")])], 1) : e._e(), e.getSearchedVehicle ? a("b-row", {
                        staticClass: "justify-content-center ml-5 mr-5"
                    }, [a("b-col", {
                        attrs: {
                            cols: "3"
                        }
                    }, [a("div", [a("span", {
                        staticClass: "police-text"
                    }, [e._v("Rejestracja")]), a("p", {
                        staticClass: "police-text-small"
                    }, [e._v(e._s(e.getSearchedVehicle.plateText))])]), a("div", [a("span", {
                        staticClass: "police-text"
                    }, [e._v("Model")]), a("p", {
                        staticClass: "police-text-small"
                    }, [e._v(e._s(e.getSearchedVehicle.vehicleModel))])]), a("div", [a("span", {
                        staticClass: "police-text"
                    }, [e._v("Właściciel")]), a("p", [a("a", {
                        directives: [{
                            name: "b-tooltip",
                            rawName: "v-b-tooltip"
                        }],
                        staticClass: "police-link",
                        attrs: {
                            title: "Kliknij aby wyszukać właściciela"
                        },
                        on: {
                            click: e.searchVehicleOwner
                        }
                    }, [e._v(e._s(e.getSearchedVehicle.ownerName))])])]), e._l(e.getVehicleTags, function(t) {
                        return a("div", [t.value ? a("p", [a("b-badge", {
                            staticStyle: {
                                "font-size": "1.5rem"
                            },
                            attrs: {
                                variant: "danger"
                            }
                        }, [e._v(e._s(t.name))])], 1) : e._e()])
                    }), a("div", [a("b-button", {
                        staticClass: "police-button",
                        on: {
                            click: e.editVehicleProfile
                        }
                    }, [e._v("Edytuj profil")])], 1)], 2), a("b-col", {
                        staticClass: "overflow-auto notes-container",
                        attrs: {
                            cols: "5"
                        }
                    }, [a("searched-notes-container", {
                        attrs: {
                            notes: e.getSearchedVehicleNotes
                        },
                        on: {
                            "add-new-note": e.openNewNoteModal
                        }
                    })], 1)], 1) : e._e()], 1), a("b-modal", {
                        ref: "modal",
                        attrs: {
                            id: "add-new-vehicle-note-modal",
                            size: "lg",
                            centered: "",
                            title: "Wprowadź nową notatkę"
                        }
                    }, [a("b-form-textarea", {
                        attrs: {
                            id: "textarea-state",
                            state: e.isFormValid(),
                            placeholder: "Wprowadź nową notatkę, minimum 10 znaków",
                            rows: "3",
                            required: ""
                        },
                        model: {
                            value: e.newNote.text,
                            callback: function(t) {
                                e.$set(e.newNote, "text", t)
                            },
                            expression: "newNote.text"
                        }
                    }), a("template", {
                        slot: "modal-footer"
                    }, [a("b-button", {
                        attrs: {
                            variant: "success"
                        },
                        on: {
                            click: e.tryAddNewNote
                        }
                    }, [e._v("\n          DODAJ\n        ")]), a("b-button", {
                        attrs: {
                            variant: "danger"
                        },
                        on: {
                            click: function(t) {
                                return e.hideModal()
                            }
                        }
                    }, [e._v("\n          ZAMKNIJ\n        ")])], 1)], 2), a("vehicle-edit-profile-modal")], 1)
                },
                s = [],
                n = (a("7f7f"), a("86e1")),
                o = a("19f6"),
                r = function() {
                    var e = this,
                        t = e.$createElement,
                        a = e._self._c || t;
                    return e.getSearchedVehicle ? a("b-modal", {
                        ref: "vehicleProfileEditModal",
                        attrs: {
                            id: "vehicle-profile-edit-modal",
                            size: "md",
                            centered: "",
                            title: "Edytuj profil"
                        },
                        on: {
                            show: e.beforeShow
                        }
                    }, [a("b-form-group", {
                        attrs: {
                            "label-cols-sm": "4",
                            label: "Rejestracja",
                            "label-for": "vehicle-modal-name"
                        }
                    }, [a("b-form-input", {
                        attrs: {
                            id: "vehicle-modal-plate-text",
                            readonly: !0,
                            value: e.getSearchedVehicle.plateText
                        }
                    })], 1), a("b-form-group", {
                        attrs: {
                            "label-cols-sm": "4",
                            label: "Model",
                            "label-for": "vehicle-modal-model"
                        }
                    }, [a("b-form-input", {
                        attrs: {
                            id: "vehicle-modal-model",
                            readonly: !0,
                            value: e.getSearchedVehicle.vehicleModel
                        }
                    })], 1), a("b-form-group", {
                        attrs: {
                            "label-cols-sm": "4",
                            label: "Właściciel",
                            "label-for": "vehicle-modal-owner"
                        }
                    }, [a("b-form-input", {
                        attrs: {
                            id: "vehicle-modal-owner",
                            readonly: !0,
                            value: e.getSearchedVehicle.ownerName
                        }
                    })], 1), a("b-form-group", {
                        staticClass: "m-0",
                        attrs: {
                            label: "Tagi",
                            "label-size": "lg"
                        }
                    }, e._l(e.tags, function(t) {
                        return a("b-form-checkbox", {
                            key: t.name,
                            on: {
                                change: function(a) {
                                    return e.changeTag(t, a)
                                }
                            },
                            model: {
                                value: t.value,
                                callback: function(a) {
                                    e.$set(t, "value", a)
                                },
                                expression: "tag.value"
                            }
                        }, [e._v(e._s(t.name))])
                    }), 1), a("template", {
                        slot: "modal-footer"
                    }, [a("b-button", {
                        attrs: {
                            variant: "success",
                            disabled: !e.isChanged
                        },
                        on: {
                            click: function(t) {
                                return e.saveChanges()
                            }
                        }
                    }, [e._v("\n        AKTUALIZUJ\n      ")]), a("b-button", {
                        attrs: {
                            variant: "danger"
                        },
                        on: {
                            click: function(t) {
                                return e.hideModal()
                            }
                        }
                    }, [e._v("\n        ZAMKNIJ\n      ")])], 1)], 2) : e._e()
                },
                l = [],
                c = {
                    name: "vehicleEditProfileModal",
                    data: function() {
                        return {
                            orignalSource: null,
                            tags: null
                        }
                    },
                    methods: {
                        beforeShow: function() {
                            this.orignalSource = JSON.parse(JSON.stringify(this.getSearchedVehicle));
                            var e = this.$store.getters.getVehicleTags,
                                t = this.getSearchedVehicle,
                                a = t.lspdTags;
                            if (this.tags = [], null != t)
                                for (var i in e) {
                                    var s = e[i];
                                    for (var n in s.value = !1, a) a[n] == s.name && (s.value = !0);
                                    this.tags.push(s)
                                }
                        },
                        hideModal: function() {
                            this.$store.commit("setSearchedVehicle", this.orignalSource), this.$refs.vehicleProfileEditModal.hide()
                        },
                        changeTag: function(e, t) {
                            for (var a in this.getSearchedVehicle.lspdTags = [], e.value = t, this.tags) {
                                e = this.tags[a];
                                e.value && this.getSearchedVehicle.lspdTags.push(e.name)
                            }
                        },
                        saveChanges: function() {
                            this.isChanged ? (this.$policeApi.post("changeVehicleData", {
                                vehicle: this.getSearchedVehicle
                            }), this.$refs.vehicleProfileEditModal.hide()) : hideModal()
                        }
                    },
                    computed: {
                        getSearchedVehicle: function() {
                            return this.$store.getters.getSearchedVehicle
                        },
                        isChanged: function() {
                            return JSON.stringify(this.orignalSource) !== JSON.stringify(this.getSearchedVehicle)
                        }
                    }
                },
                h = c,
                d = a("2877"),
                u = Object(d["a"])(h, r, l, !1, null, null, null),
                g = u.exports,
                p = {
                    name: "searchVehiclesPage",
                    components: {
                        Searchbar: n["a"],
                        SearchedNotesContainer: o["a"],
                        VehicleEditProfileModal: g
                    },
                    data: function() {
                        return {
                            newNote: {
                                text: "",
                                addedBy: "",
                                date: ""
                            }
                        }
                    },
                    methods: {
                        searchInProgress: function() {
                            return this.$store.state.searchVehicleState.inProgress
                        },
                        showNotFoundError: function() {
                            return this.$store.state.searchVehicleState.notFoundError
                        },
                        updateVehiclePlateText: function(e) {
                            this.$store.commit("SET_SEARCH_VEHICLE_PLATE_TEXT", e)
                        },
                        searchVehicle: function() {
                            this.$store.commit("clearSearchedVehicle"), this.$store.state.searchVehicleState = {
                                inProgress: !0,
                                notFoundError: !1
                            }, this.$policeApi.post("policeMdcSearchForVehicle", {
                                vehiclePlateText: this.getSearchVehiclePlateText
                            })
                        },
                        openNewNoteModal: function() {
                            this.$bvModal.show("add-new-vehicle-note-modal")
                        },
                        tryAddNewNote: function(e) {
                            e.preventDefault(), this.handleSubmit()
                        },
                        handleSubmit: function() {
                            var e = this;
                            if (this.isFormValid())
                                if (null != this.$store.state.userData) {
                                    var t = new Date(Date.now()),
                                        a = this.$store.getters.getUserName,
                                        i = String(this.$store.getters.getUserDepartmentGrade);
                                    this.newNote.addedBy = a, i && i.trim().length && (this.newNote.addedBy += " " + i), this.newNote.vehicleId = this.$store.getters.getSearchedVehicle.id, this.newNote.date = t.toLocaleDateString("en-GB") + " " + t.toLocaleTimeString("en-GB"), this.$nextTick(function() {
                                        e.hideModal()
                                    });
                                    var s = this.$policeApi.addNewVehicleNote(this.newNote);
                                    console.log("Response od servera w add vehicle notes: ".concat(JSON.stringify(s))), "error" != s && (this.$store.dispatch("addNewVehicleNote", this.newNote), this.resetModal())
                                } else this.$bvToast.toast("Wystąpił błąd, nie jesteś zalogowany do systemy. Spróbuj ponownie uruchomić tablet", {
                                    title: "Wystąpił błąd",
                                    autoHideDelay: 3500,
                                    variant: "danger",
                                    appendToast: !0
                                });
                            else this.$bvToast.toast("Walidacja się nie powiodła. Musisz uzupełnić wszystkie pola.", {
                                title: "Uzupełnij wszystkie pola",
                                autoHideDelay: 3500,
                                variant: "danger",
                                appendToast: !0
                            })
                        },
                        isFormValid: function() {
                            return this.newNote.text.length >= 10
                        },
                        resetModal: function() {
                            this.newNote = {
                                text: "",
                                addedBy: "",
                                date: ""
                            }
                        },
                        hideModal: function() {
                            this.$refs.modal.hide()
                        },
                        editVehicleProfile: function() {
                            this.$bvModal.show("vehicle-profile-edit-modal")
                        },
                        searchVehicleOwner: function() {
                            null != this.getSearchedVehicle.ownerName && (this.$store.commit("SET_SEARCH_CITIZEN_NAME", this.getSearchedVehicle.ownerName), this.$router.push({
                                name: "searchCitizensPage"
                            }))
                        }
                    },
                    computed: {
                        getVehicleTags: function() {
                            var e = this.$store.getters.getVehicleTags,
                                t = this.getSearchedVehicle,
                                a = t.lspdTags,
                                i = [];
                            if (null != t)
                                for (var s in e) {
                                    var n = e[s];
                                    for (var o in n.value = !1, a) a[o] == n.name && (n.value = !0);
                                    i.push(n)
                                }
                            return i
                        },
                        getSearchedVehicle: function() {
                            return this.$store.getters.getSearchedVehicle
                        },
                        getSearchedVehicleNotes: function() {
                            return this.$store.getters.vehicleNotesSortedByDate
                        },
                        getSearchVehiclePlateText: function() {
                            return this.$store.state.searchVehiclePlateText
                        }
                    }
                },
                f = p,
                v = Object(d["a"])(f, i, s, !1, null, null, null);
            t["default"] = v.exports
        },
        "2cc9": function(e, t, a) {
            "use strict";
            var i = a("259a"),
                s = a.n(i);
            s.a
        },
        7655: function(e, t, a) {
            "use strict";
            var i = a("d6a5"),
                s = a.n(i);
            s.a
        },
        "86e1": function(e, t, a) {
            "use strict";
            var i = function() {
                    var e = this,
                        t = e.$createElement,
                        a = e._self._c || t;
                    return a("b-col", [a("b-col", {
                        attrs: {
                            cols: "12"
                        }
                    }, [a("b-row", [a("b-col", {
                        staticClass: "text-center"
                    }, [a("p", {
                        staticClass: "police-text"
                    }, [e._v("WYSZUKAJ " + e._s(e.searchTitle))])])], 1)], 1), a("b-col", {
                        attrs: {
                            cols: "12"
                        },
                        on: {
                            keyup: function(t) {
                                return !t.type.indexOf("key") && e._k(t.keyCode, "enter", 13, t.key, "Enter") ? null : e.search(t)
                            }
                        }
                    }, [a("b-row", {
                        staticClass: "justify-content-center align-items-center"
                    }, [a("b-col", {
                        attrs: {
                            cols: "6"
                        }
                    }, [a("b-form-group", {
                        attrs: {
                            "label-for": "citizen-name-input",
                            "invalid-feedback": e.invalidFeedback,
                            state: e.state
                        }
                    }, [a("b-input-group", [a("b-form-input", {
                        attrs: {
                            id: "citizen-name-input",
                            value: e.searchString,
                            state: e.state,
                            trim: ""
                        },
                        on: {
                            input: e.changeSearchString
                        }
                    }), a("b-input-group-append", [a("b-button", {
                        staticClass: "search-button",
                        attrs: {
                            disabled: !e.state
                        },
                        on: {
                            click: e.search
                        }
                    }, [e._v("Wyszukaj")])]), a("b-input-group-append", [a("b-button", {
                        staticClass: "search-button",
                        attrs: {
                            disabled: !e.state
                        },
                        on: {
                            click: e.search
                        }
                    }, [e._v("Wyszukaj")])], 1)], 1)], 1)], 1)], 1)], 1)], 1)
                },
                s = [],
                n = a("4eaa"),
                o = {
                    props: {
                        searchTitle: {
                            type: String
                        },
                        searchString: {
                            type: String
                        }
                    },
                    data: function() {
                        return {
                            name: "",
                            regex: /^[\w\W]{5,30}$/,
                            invalidRegex: /^[\w\W]*[-()|'"]+[\w\W]*$/,
                            lastSearchPressedButtonTime: (new Date).getTime() - this.cooldownTime,
                            cooldownTime: 2500
                        }
                    },
                    methods: {
                        search: function() {
                            this.validateRegex(this.searchString) ? Object(n["a"])(this.cooldownTime, this.lastSearchPressedButtonTime) > 0 ? this.$bvToast.toast("Spokojnie kowboju, spróbuj ponownie za ".concat(Object(n["a"])(this.cooldownTime, this.lastSearchPressedButtonTime), "s"), {
                                title: "Spokojnie",
                                autoHideDelay: 3500,
                                variant: "danger",
                                appendToast: !0
                            }) : (this.lastSearchPressedButtonTime = (new Date).getTime(), this.$emit("search")) : this.$bvToast.toast("Wpisano błędne dane, spróbuj jeszcze raz", {
                                title: "Wystąpił błąd",
                                autoHideDelay: 3500,
                                variant: "danger",
                                appendToast: !0
                            })
                        },
                        validateRegex: function(e) {
                            return this.regex.test(e) && !this.invalidRegex.test(e)
                        },
                        changeSearchString: function(e) {
                            console.log("event = " + e), this.$emit("update-search-string", e)
                        }
                    },
                    computed: {
                        state: function() {
                            return this.validateRegex(this.searchString)
                        },
                        invalidFeedback: function() {
                            return this.searchString.length <= 0 ? "" : this.searchString.length < 5 ? "Wprowadź minimum 5 znaków" : this.validateRegex(this.searchString) ? "" : "Wprowadzono niedozwolone znaki"
                        }
                    }
                },
                r = o,
                l = (a("2cc9"), a("2877")),
                c = Object(l["a"])(r, i, s, !1, null, "69093a56", null);
            t["a"] = c.exports
        },
        d6a5: function(e, t, a) {}
    }
]);