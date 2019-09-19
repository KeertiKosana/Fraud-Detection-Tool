import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SpecialUseCaseResultsComponent } from './special-use-case-results.component';

describe('SpecialUseCaseResultsComponent', () => {
  let component: SpecialUseCaseResultsComponent;
  let fixture: ComponentFixture<SpecialUseCaseResultsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SpecialUseCaseResultsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SpecialUseCaseResultsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
